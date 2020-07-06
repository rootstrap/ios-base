//
//  APIClient.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
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

public typealias SuccessCallback = (
  _ responseObject: [String: Any],
  _ responseHeaders: [AnyHashable: Any]
) -> Void

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
  
  private static let emptyDataStatusCodes: Set<Int> = [204, 205]
  
  //Mandatory headers for Rails 5 API
  static let baseHeaders: [String: String] = [
    HTTPHeader.accept.rawValue: "application/json",
    HTTPHeader.contentType.rawValue: "application/json"
  ]
  
  fileprivate class func getHeaders() -> [String: String] {
    if let session = SessionManager.currentSession {
      return baseHeaders + [
        HTTPHeader.uid.rawValue: session.uid ?? "",
        HTTPHeader.client.rawValue: session.client ?? "",
        HTTPHeader.token.rawValue: session.accessToken ?? ""
      ]
    }
    return baseHeaders
  }
  
  class func getBaseUrl() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String ?? ""
  }
  
  //Recursively build multipart params to send along with media in upload requests.
  //If params includes the desired root key,
  //call this method with an empty String for rootKey param.
  class func multipartFormData(
    _ multipartForm: MultipartFormData,
    params: Any,
    rootKey: String
  ) {
    switch params.self {
    case let array as [Any]:
      for val in array {
        let forwardRootKey = rootKey.isEmpty ? "array[]" : rootKey + "[]"
        multipartFormData(multipartForm, params: val, rootKey: forwardRootKey)
      }
    case let dict as [String: Any]:
      for (key, value) in dict {
        let forwardRootKey = rootKey.isEmpty ? key : rootKey + "[\(key)]"
        multipartFormData(multipartForm, params: value, rootKey: forwardRootKey)
      }
    default:
      if let uploadData = "\(params)".data(
        using: String.Encoding.utf8,
        allowLossyConversion: false
      ) {
        let forwardRootKey = rootKey.isEmpty ?
          "\(type(of: params))".lowercased() : rootKey
        multipartForm.append(uploadData, withName: forwardRootKey)
      }
    }
  }
  
  //Multipart-form base request. Used to upload media along with desired params.
  //Note: Multipart request does not support Content-Type = application/json.
  //If your API requires this header
  //do not use this method or change backend to skip this validation.
  class func multipartRequest(
    method: HTTPMethod = .post,
    url: String,
    headers: [String: String] = APIClient.getHeaders(),
    params: [String: Any]?,
    paramsRootKey: String,
    media: [MultipartMedia],
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    
    let requestConvertible = BaseURLRequestConvertible(
      path: url,
      method: method,
      headers: headers
    )
    
    AF.upload(
      multipartFormData: { (multipartForm) -> Void in
        if let parameters = params {
          multipartFormData(multipartForm, params: parameters, rootKey: paramsRootKey)
        }
        for elem in media {
          elem.embed(inForm: multipartForm)
        }
      },
      with: requestConvertible
    )
    .responseJSON(completionHandler: { result in
      validateResult(result: result, success: success, failure: failure)
    })
  }
  
  class func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
    switch method {
    case .post, .put, .patch:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }
  
  class func request(
    _ method: HTTPMethod,
    url: String,
    params: [String: Any]? = nil,
    paramsEncoding: ParameterEncoding? = nil,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    let encoding = paramsEncoding ?? defaultEncoding(forMethod: method)
    let headers = APIClient.getHeaders()
    let requestConvertible = BaseURLRequestConvertible(
      path: url,
      method: method,
      encoding: encoding,
      params: params,
      headers: headers
    )
    
    let request = AF.request(requestConvertible)
    
    request.responseJSON(
      completionHandler: { result in
        validateResult(result: result, success: success, failure: failure)
      }
    )
  }
  
  //Handle rails-API-base errors if any
  class func handleCustomError(_ code: Int?, dictionary: [String: Any]) -> NSError? {
    if
      let messageDict = dictionary["errors"] as? [String: [String]],
      let firstKey = messageDict.keys.first
    {
      let errorsList = messageDict[firstKey]
      return NSError(
        domain: "\(firstKey) \(errorsList?.first ?? "")",
        code: code ?? 500,
        userInfo: nil
      )
    } else if let error = dictionary["error"] as? String {
      return NSError(domain: error, code: code ?? 500, userInfo: nil)
    } else if
      let errors = dictionary["errors"] as? [String: Any],
      let firstKey = errors.keys.first
    {
      let errorDesc = errors[firstKey] ?? ""
      return NSError(
        domain: "\(firstKey) " + "\(errorDesc)",
        code: code ?? 500,
        userInfo: nil
      )
    } else if dictionary["errors"] != nil || dictionary["error"] != nil {
      return NSError(
        domain: "Something went wrong. Try again later.",
        code: code ?? 500,
        userInfo: nil
      )
    }
    return nil
  }
  
  fileprivate class func validateResult(
    result: AFDataResponse<Any>,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    let defaultError = App.error(
      domain: .parsing,
      localizedDescription: "Error parsing response".localized
    )
  
    guard let response = result.response else {
      failure(defaultError)
      return
    }
    
    guard !validateEmptyResponse(
      response: response,
      data: result.data,
      success: success,
      failure: failure
    ) else { return }
    
    guard let data = result.data else {
      failure(defaultError)
      return
    }
    
    validateSerializationErrors(
      response: response,
      error: result.error,
      data: data,
      success: success,
      failure: failure
    )
  }
  
  fileprivate class func validateEmptyResponse(
    response: HTTPURLResponse,
    data: Data?,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) -> Bool {
    let defaultError = App.error(
      domain: .generic,
      localizedDescription: "Unexpected empty response".localized
    )
    
    guard let data = data, !data.isEmpty else {
      let emptyResponseAllowed = emptyDataStatusCodes.contains(
        response.statusCode
      )
      emptyResponseAllowed ?
        success([:], response.allHeaderFields) : failure(defaultError)
      return true
    }
    
    return false
  }
  
  fileprivate class func validateSerializationErrors(
    response: HTTPURLResponse,
    error: Error?,
    data: Data,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    var dictionary: [String: Any]?
    var serializationError: NSError?
    do {
      dictionary = try JSONSerialization.jsonObject(
        with: data,
        options: .allowFragments
      ) as? [String: Any]
    } catch let exceptionError as NSError {
      serializationError = exceptionError
    }
    //Check for errors in validate() or API
    if let errorOcurred = APIClient.handleCustomError(
      response.statusCode,
      dictionary: dictionary ?? [:]
    ) ?? error as NSError? {
      failure(errorOcurred)
      return
    }
    //Check for JSON serialization errors if any data received
    if let serializationError = serializationError {
      if (serializationError as NSError).code == 401 {
        AppDelegate.shared.unexpectedLogout()
      }
      failure(serializationError)
    } else {
      success(dictionary ?? [:], response.allHeaderFields)
    }
  }
}
