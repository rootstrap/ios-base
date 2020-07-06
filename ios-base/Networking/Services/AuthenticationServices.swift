//
//  AuthenticationServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationServices {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"
  
  class func login(
    email: String,
    password: String,
    success: @escaping () -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    APIClient.request(
      .post, url: url, params: parameters,
      success: { response, headers in
        AuthenticationServices.saveUserSession(fromResponse: response, headers: headers)
        success()
      },
      failure: failure
    )
  }
  
  //Multi part upload example
  //TODO: rails base backend not supporting multipart uploads yet
  class func signup(
    email: String,
    password: String,
    avatar: UIImage,
    success: @escaping (_ user: User?) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    
    guard let picData = avatar.jpegData(compressionQuality: 0.75) else {
      failure(App.error(
        domain: .parsing,
        localizedDescription: "Could not parse pic data"
      ))
      return
    }
    let image = MultipartMedia(key: "user[avatar]", data: picData)
    //Mixed base64 encoded and multipart images are supported in [MultipartMedia] param:
    //Example: let image2 = Base64Media(key: "user[image]", data: picData)
    //Then: media [image, image2]
    APIClient.multipartRequest(
      url: usersUrl,
      params: parameters,
      paramsRootKey: "",
      media: [image],
      success: { response, headers in
        AuthenticationServices.saveUserSession(fromResponse: response, headers: headers)
        success(UserDataManager.currentUser)
      },
      failure: failure
    )
  }
  
  //Example method that uploads base64 encoded image.
  class func signup(
    email: String,
    password: String,
    avatar64: UIImage,
    success: @escaping (_ user: User?) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    var parameters: [String: Any] = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    
    if let picData = avatar64.jpegData(compressionQuality: 0.75) {
      parameters["image"] = picData.asBase64Param()
    }
    
    APIClient.request(
      .post,
      url: usersUrl,
      params: parameters,
      success: { response, headers in
        AuthenticationServices.saveUserSession(fromResponse: response, headers: headers)
        success(UserDataManager.currentUser)
      },
      failure: failure
    )
  }
  
  class func logout(
    success: @escaping () -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    let url = "\(usersUrl)sign_out"
    APIClient.request(
      .delete,
      url: url,
      success: { _, _ in
        UserDataManager.deleteUser()
        SessionManager.deleteSession()
        success()
      },
      failure: failure
    )
  }
  
  class func deleteAccount(
    success: @escaping () -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    let url = "\(currentUserUrl)delete_account"
    APIClient.request(
      .delete,
      url: url,
      success: { _, _ in
        UserDataManager.deleteUser()
        SessionManager.deleteSession()
        success()
      },
      failure: failure
    )
  }
  
  class func saveUserSession(
    fromResponse response: [String: Any],
    headers: [AnyHashable: Any]
  ) {
    UserDataManager.currentUser = User(
      dictionary: response["user"] as? [String: Any] ?? [:]
    )
    if let headers = headers as? [String: Any] {
      SessionManager.currentSession = Session(headers: headers)
    }
  }
}
