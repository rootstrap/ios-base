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
  
  class func sendPostRequest(url url: String, params: [String: AnyObject]?, success:(responseObject: [String : AnyObject]) -> Void, failure:(error: NSError) -> Void) {
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(.POST, requestUrl, parameters: params, headers: header)
      .responseJSON { response in
        guard let JSONDictionary = response.result.value as? [String : AnyObject] else {
          if response.result.isSuccess || Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
            success(responseObject: ["":""])
            return
          }
          
          failure(error: NSError(domain: "Check your connection", code: 0, userInfo: nil))
          return
        }
        if Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
          success(responseObject: JSONDictionary)
        } else {
          if let messageDict = JSONDictionary["error"] as? [String: [String]] {
            let errorsList = messageDict[messageDict.keys.first!]!
            failure(error: NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: response.response!.statusCode, userInfo: nil))
          } else if let errors = JSONDictionary["errors"] as? [String] {
            failure(error: NSError(domain: errors[0], code:response.response!.statusCode, userInfo: nil))
          }
          //TODO add default error case, some cases response contains 'errors' key, but cant parse to any of above
        }
    }
  }
  
  class func sendGetRequest(url url: String, params: [String: AnyObject]?, success: (responseObject: [String : AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(.GET, requestUrl, parameters: params, headers: header)
      .responseJSON { response in
        
        guard let JSONDictionary = response.result.value as? [String : AnyObject] else {
          if response.result.isSuccess || Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
            success(responseObject: ["":""])
            return
          }
          
          failure(error: NSError(domain: "Check your connection", code: 0, userInfo: nil))
          return
        }
        if Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
          success(responseObject: JSONDictionary)
        } else {
          if let messageDict = JSONDictionary["error"] as? [String: [String]] {
            let errorsList = messageDict[messageDict.keys.first!]!
            failure(error: NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: response.response!.statusCode, userInfo: nil))
          } else if let errors = JSONDictionary["errors"] as? [String] {
            failure(error: NSError(domain: errors[0], code:response.response!.statusCode, userInfo: nil))
          }
          //TODO add default error case, some cases response contains 'errors' key, but cant parse to any of above
        }
    }
  }
  
  class func sendPutRequest(url url: String, params: [String: AnyObject]?, success: (responseObject: [String : AnyObject]) -> Void, failure: (error: NSError) -> Void) {
    let header = CommunicationManager.getHeader()
    let requestUrl = getBaseUrl() + url
    Alamofire.request(.PUT, requestUrl, parameters: params, headers: header)
      .responseJSON { response in
        guard let JSONDictionary = response.result.value as? [String : AnyObject] else {
          if response.result.isSuccess || Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
            success(responseObject: ["":""])
            return
          }
          
          failure(error: NSError(domain: "Check your connection", code: 0, userInfo: nil))
          return
        }
        if Range(start: 200, end: 210).contains(response.response?.statusCode ?? 500) {
          success(responseObject: JSONDictionary)
        } else {
          if let messageDict = JSONDictionary["error"] as? [String: [String]] {
            let errorsList = messageDict[messageDict.keys.first!]!
            failure(error: NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: response.response!.statusCode, userInfo: nil))
          } else if let errors = JSONDictionary["errors"] as? [String] {
            failure(error: NSError(domain: errors[0], code:response.response!.statusCode, userInfo: nil))
          }
          //TODO add default error case, some cases response contains 'errors' key, but cant parse to any of above
        }
    }
  }
}
