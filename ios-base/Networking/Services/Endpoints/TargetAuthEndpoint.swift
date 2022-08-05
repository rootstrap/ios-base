//
//  TargetAuthEndpoint.swift
//  ios-base
//
//  Created by Lucas Miotti on 25/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import Moya

enum TargetAuthEndpoint {
  case signIn(email: String, password: String)
  case register(
    username: String,
    email: String,
    gender: String,
    password: String,
    passwordConfirmation: String
  )
  case authWithFacebook(accessToken: String)
}

extension TargetAuthEndpoint: TargetType {
  var baseURL: URL {
    URL(string: "https://target-mvd-api.herokuapp.com/api/v1")!
  }
  
  var task: Task {
    switch self {
    case .signIn(let email, let password):
      let parameters = [
        "email": email,
        "password": password
      ]
        return .requestParameters(parameters: [
          "user": parameters], encoding: JSONEncoding.default)
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
      return .requestParameters(parameters: [
        "user": parameters], encoding: JSONEncoding.default)
    case .authWithFacebook(
      let accessToken
    ):
      return .requestParameters(parameters: [
        "user": accessToken
      ], encoding: JSONEncoding.default)
    }
  }
  
  var path: String {
    switch self {
    case .signIn:
      return "/users/sign_in"
    case .register:
      return "/users"
    case .authWithFacebook:
      return "users/facebook"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .signIn, .register, .authWithFacebook:
      return .post
    }
  }
  
  var headers: [String : String]? {
    ["Content-Type": "application/json"]
  }
}

struct UserRequest: Codable {
  let user: UserDataRequest
  
  private enum CodingKeys: String, CodingKey {
    case user
  }
}

struct UserDataRequest: Codable {
  let email: String
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case email
    case password
  }
}
