//
//  APIClient.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import Alamofire

public enum SwiftBaseErrorCode: Int {
  case inputStreamReadFailed           = -6000
  case outputStreamWriteFailed         = -6001
  case contentTypeValidationFailed     = -6002
  case statusCodeValidationFailed      = -6003
  case dataSerializationFailed         = -6004
  case stringSerializationFailed       = -6005
  case jsonSerializationFailed         = -6006
  case propertyListSerializationFailed = -6007
}

public typealias SuccessCallback = (_ responseObject: [String: Any], _ responseHeaders: [AnyHashable: Any]) -> Void
public typealias FailureCallback = (_ error: Error) -> Void

class APIClient {
  
  enum HTTPHeader: String {
    case uid = "uid"
    case client = "client"
    case token = "access-token"
    case expiry = "expiry"
    case accept = "Accept"
    case contentType = "Content-Type"
  }
  
  //Mandatory headers for Rails 5 API
  static let baseHeaders: [String: String] = [HTTPHeader.accept.rawValue: "application/json",
                                              HTTPHeader.contentType.rawValue: "application/json"]
  
  fileprivate class func getHeader() -> [String: String]? {
    if let session = SessionManager.currentSession {
      return baseHeaders + [
        HTTPHeader.uid.rawValue: session.uid ?? "",
        HTTPHeader.client.rawValue: session.client ?? "",
        HTTPHeader.token.rawValue: session.accessToken ?? ""
      ]
    }
    return baseHeaders
  }
  
  fileprivate class func getBaseUrl() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String ?? ""
  }
  
  //Recursively build multipart params to send along with media in upload requests.
  //If params includes the desired root key, call this method with an empty String for rootKey param.
  class func multipartFormData(_ multipartForm: MultipartFormData, params: Any, rootKey: String) {
    switch params.self {
    case let array as [Any]:
      for val in array {
        let forwardRootKey = rootKey.isEmpty ? "array[]" : rootKey + "[]"
        multipartFormData(multipartForm, params: val, rootKey: forwardRootKey)
      }
    case let dict as [String: Any]:
      for (k, v) in dict {
        let forwardRootKey = rootKey.isEmpty ? k : rootKey + "[\(k)]"
        multipartFormData(multipartForm, params: v, rootKey: forwardRootKey)
      }
    default:
      if let uploadData = "\(params)".data(using: String.Encoding.utf8, allowLossyConversion: false) {
        let forwardRootKey = rootKey.isEmpty ? "\(type(of: params))".lowercased() : rootKey
        multipartForm.append(uploadData, withName: forwardRootKey)
      }
    }
  }
  
  //Multipart-form base request. Used to upload media along with desired params.
  //Note: Multipart request does not support Content-Type = application/json.
  //If your API requires this header do not use this method or change backend to skip this validation.
  class func multipartRequest(_ method: HTTPMethod = .post,
                              url: String,
                              headers: [String: String]? = nil,
                              params: [String: Any]?,
                              paramsRootKey: String,
                              media: [MultipartMedia],
                              success: @escaping SuccessCallback,
                              failure: @escaping FailureCallback) {
    
    let header = APIClient.getHeader()
    let requestUrl = getBaseUrl() + url
    
    Alamofire.upload(multipartFormData: { (multipartForm) -> Void in
      if let parameters = params {
        multipartFormData(multipartForm, params: parameters, rootKey: paramsRootKey)
      }
      for elem in media {
        elem.embed(inForm: multipartForm)
      }
      
    }, to: requestUrl, method: method, headers: header, encodingCompletion: { (encodingResult) -> Void in
      switch encodingResult {
      case .success(let upload, _, _):
        upload.validate()
          .responseDictionary { response in
            validateResult(ofResponse: response, success: success, failure: failure)
        }
      case .failure(let encodingError):
        failure(encodingError)
      }
    })
  }
  
  class func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
    switch method {
    case .post, .put:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }
  
  class func request(_ method: HTTPMethod, url: String, params: [String: Any]? = nil, paramsEncoding: ParameterEncoding? = nil, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    let encoding = paramsEncoding ?? defaultEncoding(forMethod: method)
    let header = APIClient.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(requestUrl, method: method, parameters: params, encoding: encoding, headers: header)
      .validate()
      .responseDictionary { response in
        validateResult(ofResponse: response, success: success, failure: failure)
    }
  }
  
  fileprivate class func validateResult(ofResponse response: DataResponse<[String: Any]>,
                                        success: @escaping SuccessCallback,
                                        failure: @escaping FailureCallback) {
    switch response.result {
    case .success(let dictionary):
      if let urlResponse = response.response {
        success(dictionary, urlResponse.allHeaderFields)
      }
      return
    case .failure(let error):
      failure(error)
      if (error as NSError).code == 401 { //Unauthorized user
        AppDelegate.shared.unexpectedLogout()
      }
    }
  }
  
  //Handle rails-API-base errors if any
  class func handleCustomError(_ code: Int?, dictionary: [String: Any]) -> NSError? {
    if let messageDict = dictionary["errors"] as? [String: [String]] {
      let errorsList = messageDict[messageDict.keys.first!]!
      return NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: code ?? 500, userInfo: nil)
    } else if let error = dictionary["error"] as? String {
      return NSError(domain: error, code: code ?? 500, userInfo: nil)
    } else if let errors = dictionary["errors"] as? [String: Any] {
      let errorDesc = errors[errors.keys.first!]!
      return NSError(domain: "\(errors.keys.first!) " + "\(errorDesc)", code: code ?? 500, userInfo: nil)
    } else if dictionary["errors"] != nil || dictionary["error"] != nil {
      return NSError(domain: "Something went wrong. Try again later.", code: code ?? 500, userInfo: nil)
    }
    return nil
  }
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension DataRequest {
  public static func responseDictionary() -> DataResponseSerializer<[String: Any]> {
    return DataResponseSerializer { _, response, data, requestError in
      let emptyResponseAllowed = emptyDataStatusCodes.contains(response?.statusCode ?? 0)
      guard let data = data, !data.isEmpty else {
        return emptyResponseAllowed ? .success([:]) : .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
      }
      var dictionary: [String: Any]?
      var serializationError: NSError?
      do {
        dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      } catch let exceptionError as NSError {
        serializationError = exceptionError
      }
      //Check for errors in validate() or API
      if let errorOcurred = APIClient.handleCustomError(response?.statusCode, dictionary: dictionary ?? [:]) ?? requestError {
        return .failure(errorOcurred)
      }
      //Check for JSON serialization errors if any data received
      return serializationError == nil ? .success(dictionary ?? [:]) : .failure(serializationError!)
    }
  }
  
  @discardableResult
  func responseDictionary(
    _ queue: DispatchQueue? = nil,
    completionHandler: @escaping (DataResponse<[String: Any]>) -> Void) -> Self {
    return response(
      queue: queue,
      responseSerializer: DataRequest.responseDictionary(),
      completionHandler: completionHandler
    )
  }
}

//Helper to retrieve the right string value for base64 API uploaders
extension Data {
  func asBase64Param(withType type: MimeType = .jpeg) -> String {
    return "data:\(type.rawValue);base64,\(self.base64EncodedString())"
  }
}
