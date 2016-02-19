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
  
  private static let usersUrl = "/users/"
  
  class func login(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    CommunicationManager.sendPostRequest(url: url, params: parameters,
      success: { (responseObject) -> Void in
        success(responseObject: "")
      }) { (error) -> Void in
        failure(error: error)
    }
  }
  
  class func signup(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
    let url = usersUrl
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    CommunicationManager.sendPostRequest(url: url, params: parameters,
      success: { (responseObject) -> Void in
        success(responseObject: "")
      }) { (error) -> Void in
        failure(error: error)
    }
  }
  
  class func loginWithFacebook(email email: String, firstName: String, lastName: String, facebookId: String, success:(responseObject: String) -> Void, failure: (error: NSError) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "facebook_id": facebookId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email
      ],
      "type": "facebook"
    ]
    CommunicationManager.sendPostRequest(url: url, params: parameters,
      success: { (responseObject) -> Void in
        let json = JSON(responseObject)
        success(responseObject: json["token"].stringValue)
      }) { (error) -> Void in
        failure(error: error)
    }
  }
  
}
