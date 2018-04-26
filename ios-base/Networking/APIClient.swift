//
//  APIClient.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
  class func sendMultipartRequest(_ method: HTTPMethod = .post,
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
          .responseDictionary { (response) -> Void in
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
      case .failure(let encodingError):
        failure(encodingError)
      }
    })
  }
  
  class func sendPostRequest(_ url: String, params: [String: Any]?, paramsEncoding: ParameterEncoding = JSONEncoding.default, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    sendBaseRequest(.post, url: url, params: params, paramsEncoding: paramsEncoding, success: success, failure: failure)
  }
  
  class func sendGetRequest(_ url: String, params: [String: Any]? = nil, paramsEncoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    sendBaseRequest(.get, url: url, params: params, paramsEncoding: paramsEncoding, success: success, failure: failure)
  }
  
  class func sendPutRequest(_ url: String, params: [String: Any]?, paramsEncoding: ParameterEncoding = JSONEncoding.default, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    sendBaseRequest(.put, url: url, params: params, paramsEncoding: paramsEncoding, success: success, failure: failure)
  }
  
  class func sendDeleteRequest(_ url: String, params: [String: Any]? = nil, paramsEncoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    sendBaseRequest(.delete, url: url, params: params, paramsEncoding: paramsEncoding, success: success, failure: failure)
  }
  
  class func sendBaseRequest(_ method: HTTPMethod, url: String, params: [String: Any]?, paramsEncoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
    let header = APIClient.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(requestUrl, method: method, parameters: params, encoding: paramsEncoding, headers: header)
      .validate()
      .responseDictionary { (response) -> Void in
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

extension DataRequest {
  public static func responseDictionary() -> DataResponseSerializer<[String: Any]> {
    return DataResponseSerializer { _, response, data, requestError in
      guard let data = data else {
        let failureReason = "Data could not be serialized. Input data was nil."
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: "\(Bundle.main.bundleIdentifier!).error", code: SwiftBaseErrorCode.dataSerializationFailed.rawValue, userInfo: userInfo)
        return .failure(error)
      }
      
      var serializationError: NSError?
      let json = JSON(data: data, options: .allowFragments, error: &serializationError)
      //There was an error in validate(), JSON serialization or an API error
      if let errorOcurred = requestError ?? APIClient.handleCustomError(response?.statusCode, dictionary: json.dictionaryObject ?? [:]) {
        return .failure(errorOcurred)
      }
      return !data.isEmpty && serializationError != nil ? .failure(serializationError!) : .success(json.dictionaryObject ?? [:])
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
