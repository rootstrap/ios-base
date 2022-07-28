//
//  TargetAuthEndpoint.swift
//  ios-base
//
//  Created by Lucas Miotti on 25/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

enum TargetAuthEndpoint: RailsAPIEndpoint {
  
  case signIn(email: String, password: String)
  case register(
    username: String,
    email: String,
    gender: String,
    password: String,
    passwordConfirmation: String
  )
  
  var path: String {
    switch self {
    case .signIn:
      return "users/sign_in"
    case .register:
      return "users"
    }
  }
  
  var method: Network.HTTPMethod {
    switch self {
    case .signIn, .register:
      return .post
    }
  }
  
  var parameters: [String : Any] {
    switch self {
    case .signIn(let email, let password):
      return [
        "user": [
          "email": email,
          "password": password
        ]
      ]
    case .register(
      let username,
      let email,
      let gender,
      let password,
      let passwordConfirmation
    ):
      let parameters = [
        "username": username,
        "email": email,
        "gender": gender,
        "password": password,
        "password_confirmation": passwordConfirmation
      ]
      return ["user": parameters]
    }
  }
  
  var headers: [String : String] {
    ["Content-Type":"application/json"]
  }
}
