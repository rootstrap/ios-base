//
//  UserServiceManager.swift
//  swift-base
//
//  Created by TopTier labs on 16/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserServiceManager {
  
  fileprivate static let usersUrl = "/users/"

  class func login(email: String, password: String, success:@escaping (_ responseObject: String?) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    CommunicationManager.sendPostRequest(url, params: parameters as [String : AnyObject]?,
      success: { (responseObject) -> Void in
        success("")
      }) { (error) -> Void in
        failure(error)
    }
  }

  class func signup(email: String, password: String, success:@escaping (_ responseObject: String?) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    CommunicationManager.sendPostRequest(
      url, params: parameters as [String : AnyObject]?,
      success: { (responseObject) -> Void in
        success("")
      }) { (error) -> Void in
        failure(error)
    }
  }

  class func getMyProfile(success: @escaping (_ json: JSON) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "me"
    CommunicationManager.sendGetRequest(url, params: nil, success: { (responseObject) in
      let json = JSON(responseObject)
      success(json)
      }) { (error) in
        failure(error)
    }
  }

  class func loginWithFacebook(email: String, firstName: String, lastName: String, facebookId: String, token:String, success:@escaping (_ responseObject: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "facebook"
    let parameters = [
        "access_token": token,
        "user": [
          "facebook_id": facebookId,
          "first_name": firstName,
          "last_name": lastName,
          "email": email
        ]
    ] as [String : Any]
    CommunicationManager.sendPostRequest(url, params: parameters as [String : AnyObject]?,
      success: { (responseObject) -> Void in
        let json = JSON(responseObject)
        print(json)
      }) { (error) -> Void in
        failure(error)
    }
  }
}
