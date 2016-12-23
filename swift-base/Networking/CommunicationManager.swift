//
//  CommunicationManager.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
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
    case jSONSerializationFailed         = -6006
    case propertyListSerializationFailed = -6007
}

class CommunicationManager {

  fileprivate class func getHeader() -> [String: String]? {
    return UserDataManager.getSessionToken() != nil ? ["X-USER-TOKEN": "\(UserDataManager.getSessionToken()!)"] : nil
  }

  fileprivate class func getBaseUrl() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String ?? ""
  }

  fileprivate class func isOk(statusCode: Int?) -> Bool {
    return Range(200 ..< 211).contains(statusCode ?? 500)
  }
  
  //Recursively build multipart params to send along with media in upload requests.
  //If params includes the desired root key, call this method with an empty String for rootKey param.
  class func multipartFormData(multipartForm: MultipartFormData, params: [String:AnyObject], rootKey: String) {
    for (key, value) in params {
      switch value.self {
      case is [Int], is [String]:
        if let array = value as? [Int] {
          for val in array {
            if let uploadData = "\(val)".data(using: String.Encoding.utf8, allowLossyConversion: false) {
              multipartForm.append(uploadData, withName:  "\(rootKey)[\(key)][]")
            }
          }
        }
        break
      case is [AnyObject]:
        if let array = value as? [AnyObject] {
          for val in array {
            multipartFormData(multipartForm: multipartForm, params: ["\(key)": val], rootKey: "[\(rootKey)][\(key)][]")
          }
        }
        break
      case is [String:AnyObject]:
        if let subParams = value as? [String:AnyObject] {
          multipartFormData(multipartForm: multipartForm, params: subParams, rootKey: "[\(rootKey)][\(key)]")
        }
        break
      default:
        if let uploadData = "\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false) {
          multipartForm.append(uploadData , withName: "\(rootKey)[\(key)]")
        }
        break
      }
    }
  }
  
  //Upload post request. Change the mediaType param to whatever type you need(default is String to match constants for media types provided in swift-base project).
  //TODO: Change method to support multiple media upload with an [NSData]
  class func sendPostRequest(url: String, params: [String: AnyObject]?, paramsRootKey: String , media: Data, mediaKey: String, mediaType: String, success:@escaping (_ responseObject: [String : AnyObject]) -> Void, failure:@escaping (_ error: Error) -> Void) {
    
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url

    Alamofire.upload(multipartFormData: { (multipartForm) -> Void in
      if let parameters = params {
        multipartFormData(multipartForm: multipartForm, params: parameters, rootKey: paramsRootKey)
      }
      
      if mediaType == videoType {
        multipartForm.append(media, withName: mediaKey, fileName: "fileName.mov", mimeType: "video/quicktime")
      }else {
        multipartForm.append(media, withName: mediaKey, fileName: "fileName.jpg", mimeType: "image/jpg")
      }
      
    }, to: requestUrl, headers: header, encodingCompletion: { (encodingResult) -> Void in
        switch encodingResult {
        case .success(let upload, _, _):
          upload.validate()
            .responseDictionary { (response) -> Void in
              switch response.result {
              case .success(let dictionary):
                success(dictionary as [String : AnyObject])
                return
              case .failure(let error):
                failure(error as Error)
              }
          }
          
        case .failure(let encodingError):
          failure(encodingError as Error)
        }
    })
  }
  

  class func sendPostRequest(url: String, params: [String: AnyObject]?, success: @escaping (_ responseObject: [String: AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    sendBaseRequest(method: .post, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendGetRequest(url: String, params: [String: AnyObject]?, success: @escaping (_ responseObject: [String: AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    sendBaseRequest(method: .get, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendPutRequest(url: String, params: [String: AnyObject]?, success: @escaping (_ responseObject: [String: AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    sendBaseRequest(method: .put, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendDeleteRequest(url: String, params: [String: AnyObject]?, success: @escaping (_ responseObject: [String: AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    sendBaseRequest(method: .delete, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendBaseRequest(method: HTTPMethod, url: String, params: [String: AnyObject]?, success: @escaping (_ responseObject: [String: AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(requestUrl, method: method, parameters: params, headers: header)
      .validate()
      .responseDictionary { (response) -> Void in
        switch response.result {
        case .success(let dictionary):
          success(dictionary as [String : AnyObject])
          return
        case .failure(let error):
          
          failure(error)
        }
    }
  }
  
  
  //Handle rails-API-base errors if any
  class func handleCustomError(code: Int?, dictionary: [String: AnyObject]) -> NSError?  {
    if let messageDict = dictionary["errors"] as? [String: [String]] {
      let errorsList = messageDict[messageDict.keys.first!]!
      return NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: code ?? 500, userInfo: nil)
    } else if let errors = dictionary["errors"] as? [String] {
      return NSError(domain: errors[0], code:code ?? 500, userInfo: nil)
    } else if let errors = dictionary["errors"] as? [String: AnyObject] {
      let errorDesc = errors[errors.keys.first!]!
      return NSError(domain: "\(errors.keys.first!) " + "\(errorDesc)", code:code ?? 500, userInfo: nil)
    } else if dictionary["errors"] != nil || dictionary["error"] != nil{
      return NSError(domain: "Something went wrong. Try again later.", code:code ?? 500, userInfo: nil)
    }
    return nil
  }
  
}

extension DataRequest {
  
  public static func responseDictionary() -> DataResponseSerializer<[String: Any]> {
    return DataResponseSerializer { request, response, data, error in
      
      guard let _ = data else {
        let failureReason = "Data could not be serialized. Input data was nil."
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: "\(Bundle.main.bundleIdentifier!).error", code: SwiftBaseErrorCode.dataSerializationFailed.rawValue, userInfo: userInfo)
        return .failure(error)
      }
      
      var anError: NSError?
      let json = JSON.init(data: data!, options: .allowFragments, error: &anError)
      if json.type != .null {
        if let dictionary = json.dictionaryObject {
          if let customError = CommunicationManager.handleCustomError(code: response?.statusCode, dictionary: dictionary as [String : AnyObject]) {
            return .failure(customError)
          }
          guard error == nil else {
            return .failure(error!)
          }
          return .success(dictionary)
        }
        return .success(["":""])
      }
      //There was no error in validate()
      guard error != nil else {
        return .success(["":""])
      }
      
      return .failure(NSError(domain: "Check your connection", code: 0, userInfo: nil))
    }
  }

  @discardableResult
  func responseDictionary(
    queue: DispatchQueue? = nil,
    completionHandler: @escaping (DataResponse<[String: Any]>) -> Void)
    -> Self
  {
    return response(
      queue: queue,
      responseSerializer: DataRequest.responseDictionary(),
      completionHandler: completionHandler
    )
  }
}
