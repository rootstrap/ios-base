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

  class func login(_ email: String, password: String, success: @escaping (_ responseObject: String?) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    CommunicationManager.sendPostRequest(url, params: parameters as [String : AnyObject]?,
      success: { (_) -> Void in
        success("")
    }) { (error) -> Void in
        failure(error)
    }
  }

  class func signup(_ email: String, password: String, success: @escaping (_ responseObject: String?) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    CommunicationManager.sendPostRequest(url, params: parameters as [String : AnyObject]?,
      success: { (_) -> Void in
        success("")
    }) { (error) -> Void in
        failure(error)
    }
  }

  class func getMyProfile(_ success: @escaping (_ json: JSON) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "me"
    CommunicationManager.sendGetRequest(url, success: { (responseObject) in
      let json = JSON(responseObject)
      success(json)
    }) { (error) in
        failure(error)
    }
  }

  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "facebook"
    let parameters = [
      "access_token": token
      ] as [String : Any]
    CommunicationManager.sendPostRequest(url, params: parameters as [String : AnyObject]?,
      success: { (responseObject) -> Void in
        let json = JSON(responseObject)
        UserDataManager.storeUserObject(User.parse(fromJSON: json))
        success()
    }) { (error) -> Void in
      failure(error)
    }
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_out"
    CommunicationManager.sendDeleteRequest(url, success: { (responseObject) in
      SessionDataManager.deleteSessionObject()
      success()
    }) { (error) -> Void in
      failure(error)
    }
  }
}
