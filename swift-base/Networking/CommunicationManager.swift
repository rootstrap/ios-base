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

class CommunicationManager {

  private class func getHeader() -> [String: String]? {
    return UserDataManager.getSessionToken() != nil ? ["X-USER-TOKEN": "\(UserDataManager.getSessionToken()!)"] : nil
  }

  private class func getBaseUrl() -> String {
    return NSBundle.mainBundle().objectForInfoDictionaryKey("Base URL") as? String ?? ""
  }

  private class func isOkStatus(code: Int?) -> Bool {
    return Range(start: 200, end: 210).contains(code ?? 500)
  }
  
  //Recursively build multipart params to send along with media in upload requests.
  //If params includes the desired root key, call this method with an empty String for rootKey param.
  class func multipartFormDataWithParams(multipartForm: MultipartFormData, params: [String:AnyObject], rootKey: String) {
    for (key, value) in params {
      switch value.self {
      case is [Int], is [String]:
        if let array = value as? [Int] {
          for val in array {
            if let uploadData = "\(val)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
              multipartForm.appendBodyPart(data: uploadData , name: "\(rootKey)[\(key)][]")
            }
          }
        }
        break
      case is [AnyObject]:
        if let array = value as? [AnyObject] {
          for val in array {
            multipartFormDataWithParams(multipartForm, params: ["\(key)": val], rootKey: "[\(rootKey)][\(key)][]")
          }
        }
        break
      case is [String:AnyObject]:
        if let subParams = value as? [String:AnyObject] {
          multipartFormDataWithParams(multipartForm, params: subParams, rootKey: "[\(rootKey)][\(key)]")
        }
        break
      default:
        if let uploadData = "\(value)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
          multipartForm.appendBodyPart(data: uploadData , name: "\(rootKey)[\(key)]")
        }
        break
      }
    }
  }
  
  //Upload post request. Change the mediaType param to whatever type you need(default is String to match constants for media types provided in swift-base project).
  //TODO: Change method to support multiple media upload with an [NSData]
  class func sendPostRequest(url url: String, params: [String: AnyObject]?, paramsRootKey: String , media: NSData, mediaKey: String, mediaType: String, success:(responseObject: [String : AnyObject]) -> Void, failure:(error: NSError) -> Void) {
    
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.upload(.POST, requestUrl, headers: header, multipartFormData: { (multipartFormData) -> Void in
      if let parameters = params {
        multipartFormDataWithParams(multipartFormData, params: parameters, rootKey: paramsRootKey)
      }
      
      if mediaType == videoType {
        multipartFormData.appendBodyPart(data: media, name: mediaKey, fileName: "fileName.mov", mimeType: "video/quicktime")
      }else {
        multipartFormData.appendBodyPart(data: media, name: mediaKey, fileName: "fileName.jpg", mimeType: "image/jpg")
      }
      
      }, encodingCompletion: { (encodingResult) -> Void in
        switch encodingResult {
        case .Success(let upload, _, _):
          upload.validate()
            .responseDictionary { (response) -> Void in
              switch response.result {
              case .Success(let dictionary):
                success(responseObject: dictionary)
                return
              case .Failure(let error):
                failure(error: error)
              }
          }
          
        case .Failure(let encodingError):
          failure(error: encodingError as NSError)
        }
    })
  }
  

  class func sendPostRequest(url url: String, params: [String: AnyObject]?, success:(responseObject: [String: AnyObject]) -> Void, failure:(error: NSError) -> Void) {
    sendBaseRequest(.POST, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendGetRequest(url url: String, params: [String: AnyObject]?, success: (responseObject: [String: AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    sendBaseRequest(.GET, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendPutRequest(url url: String, params: [String: AnyObject]?, success: (responseObject: [String: AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    sendBaseRequest(.PUT, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendDeleteRequest(url url: String, params: [String: AnyObject]?, success: (responseObject: [String: AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    sendBaseRequest(.DELETE, url: url, params: params, success: success, failure: failure)
  }
  
  class func sendBaseRequest(method: Alamofire.Method, url: String, params: [String: AnyObject]?, success: (responseObject: [String: AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(method, requestUrl, parameters: params, headers: header)
      .validate()
      .responseDictionary { (response) -> Void in
        switch response.result {
        case .Success(let dictionary):
          success(responseObject: dictionary)
          return
        case .Failure(let error):
          
          failure(error: error)
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

extension Alamofire.Request {
  
  //Hanldes server response for base requests
  //Success: Return a dictionary if any
  //Failure: Returns NSError. Custom errors have preference over Alamofire validation errors.
  
  public static func responseDictionary() -> ResponseSerializer<[String: AnyObject], NSError> {
    return ResponseSerializer { request, response, data, error in
      
      guard let _ = data else {
        let failureReason = "Data could not be serialized. Input data was nil."
        let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
        return .Failure(error)
      }
      
      var anError: NSError?
      let json = JSON.init(data: data!, options: .AllowFragments, error: &anError)
      if json.type != .Null {
        if let dictionary = json.dictionaryObject {
          if let customError = CommunicationManager.handleCustomError(response?.statusCode, dictionary: dictionary) {
            return .Failure(customError)
          }
          guard error == nil else {
            return .Failure(error!)
          }
          return .Success(dictionary)
        }
        return .Success(["":""])
      }
      //There was no error in validate()
      guard error != nil else {
        return .Success(["":""])
      }
      
      return .Failure(NSError(domain: "Check your connection", code: 0, userInfo: nil))
    }
  }
  
  public func responseDictionary(completionHandler: Response<[String: AnyObject], NSError> -> Void) -> Self {
    return response(responseSerializer: Request.responseDictionary(), completionHandler: completionHandler)
  }
}
