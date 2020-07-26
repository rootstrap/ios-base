//
//  UserResource.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import Moya

enum UserResource: TargetType {

  case login(String, String)
  case signup(String, String, UIImage)
  case signupMultipart(String, String, UIImage)
  case profile
  case fbLogin(String)
  case logout
  case deleteAccount

  var path: String {
    let authBasePath = "/users"
    let userBasePath = "/user"
    switch self {
    case .login:
      return "\(authBasePath)/sign_in"
    case .signup:
      return authBasePath
    case .signupMultipart:
      return authBasePath
    case .profile:
      return "\(userBasePath)/profile"
    case .fbLogin:
      return "\(userBasePath)/facebook"
    case .logout:
      return "\(authBasePath)/sign_out"
    case .deleteAccount:
      return "\(userBasePath)/delete_account"
    }
  }

  var method: Moya.Method {
    switch self {
    case .signupMultipart, .signup, .login, .fbLogin:
      return .post
    case .profile:
      return .get
    case .logout, .deleteAccount:
      return .delete
    }
  }

  var headers: [String: String]? {
    switch  self {
    case .signupMultipart:
      return [:]
    default:
      return getHeaders()
    }
  }

  var task: Task {
    switch self {
    case .login(let email, let password):
      let parameters = getLoginParams(email: email, password: password)
      return requestParameters(parameters: parameters)
    case .signup(let email, let password, let avatar64):
      let parameters = getSignUpParams(email: email, password: password, avatar: avatar64)
      return requestParameters(parameters: parameters)
    case .signupMultipart(let email, let password, let avatar):
      let parameters = getSignUpMultipartParams(
        email: email, password: password, avatar: avatar
      )
      return .uploadMultipart(multipartData(from: parameters, rootKey: "user"))
    case .fbLogin(let token):
      let parameters = [
        "access_token": token
      ]
      return requestParameters(parameters: parameters)
    default:
      return .requestPlain
    }
  }

  private func getLoginParams(email: String, password: String) -> [String: Any] {
    return [
      "user": [
        "email": email,
        "password": password
      ]
    ]
  }

  private func getSignUpParams(
    email: String, password: String, avatar: UIImage
  ) -> [String: Any] {
    let picData = avatar.jpegData(compressionQuality: 0.75) ?? Data()
    return [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "image": picData.asBase64Param()
      ]
    ]
  }

  private func getSignUpMultipartParams(
    email: String, password: String, avatar: UIImage
  ) -> [String: Any] {
    return [
      "email": email,
      "password": password,
      "password_confirmation": password,
      "image": avatar.jpegData(compressionQuality: 0.75) ?? Data()
    ]
  }
}
