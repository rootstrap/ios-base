//
//  UserServiceManager.swift
//  ios-base
//
//  Created by Rootstrap on 16/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserAPI {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"

  class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    APIClient.sendPostRequest(url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      failure(error)
    })
  }

  //Example method that uploads an image using multipart-form.
  class func signup(_ email: String, password: String, avatar: UIImage, success: @escaping (_ responseObject: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    
    let picData = UIImageJPEGRepresentation(avatar, 0.75)!
    let image = MultipartMedia(key: "user[avatar]", data: picData)
    //Mixed base64 encoded and multipart images are supported in [MultipartMedia] param:
    //Example: let image2 = Base64Media(key: "user[image]", data: picData) Then: media [image, image2]
    APIClient.sendMultipartRequest(url: usersUrl, params: parameters, paramsRootKey: "", media: [image], success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success(response)
    }, failure: { (error) in
      failure(error)
    })
  }

  //Example method that uploads base64 encoded image.
  class func signup(_ email: String, password: String, avatar64: UIImage, success: @escaping (_ responseObject: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let picData = UIImageJPEGRepresentation(avatar64, 0.75)
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "image": picData!.asBase64Param()
      ]
    ]
    
    APIClient.sendPostRequest(usersUrl, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success(response)
    }, failure: { error in
      failure(error)
    })
  }

  class func getMyProfile(_ success: @escaping (_ user: User) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "profile"
    APIClient.sendGetRequest(url, success: { response, _ in
      let json = JSON(response)
      success(User(json: json["user"]))
    }, failure: { error in
      failure(error)
    })
  }

  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "facebook"
    let parameters = [
      "access_token": token
    ]
    APIClient.sendPostRequest(url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
  class func saveUserSession(fromResponse response: [String: Any], headers: [AnyHashable: Any]) {
    let json = JSON(response)
    UserDataManager.currentUser = User(json: json["user"])
    if let headers = headers as? [String: Any] {
      SessionManager.currentSession = Session.parse(from: headers)
    }
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_out"
    APIClient.sendDeleteRequest(url, success: { _ in
      UserDataManager.deleteUser()
      SessionManager.deleteSession()
      success()
    }, failure: { error in
      failure(error)
    })
  }
}
