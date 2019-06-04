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
  case logout

  var path: String {
    let basePath = "/users/"
    switch self {
    case .login:
      return "\(basePath)/sign_in"
    case .logout:
      return "\(basePath)/sign_out"
    }
  }

  var method: Moya.Method {
    switch self {
    case .login:
      return .post
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
    case .logout:
      return .requestPlain
    }
  }
}
