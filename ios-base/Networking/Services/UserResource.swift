//
//  UserResource.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
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
    }
  }

  var method: Moya.Method {
    switch self {
    case .signupMultipart, .signup, .login, .fbLogin:
      return .post
    case .profile:
      return .get
    case .logout:
      return .delete
    }
  }

  var task: Task {
    switch self {
    case .login(let email, let password):
      return requestParameters(
        parameters: [
          "user": [
            "email": email,
            "password": password
          ]
        ]
      )
    case .signup(let email, let password, let avatar64):
      let picData = avatar64.jpegData(compressionQuality: 0.75) ?? Data()
      let parameters = [
        "user": [
          "email": email,
          "password": password,
          "password_confirmation": password,
          "image": picData.asBase64Param()
        ]
      ]
      return requestParameters(parameters: parameters)
    case .signupMultipart(let email, let password, let avatar):
      let parameters: [String: Any] = [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "image": avatar.jpegData(compressionQuality: 0.75) ?? Data()
      ]
      return .uploadMultipart(multipartData(from: parameters))
    case .fbLogin(let token):
      let parameters = [
        "access_token": token
      ]
      return requestParameters(parameters: parameters)
    default:
      return .requestPlain
    }
  }
}
