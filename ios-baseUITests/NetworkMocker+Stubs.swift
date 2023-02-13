//
//  NetworkMockerExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 6/30/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation
import RSSwiftNetworking

internal enum NetworkStub {
  case signUp(success: Bool)
  case signIn(success: Bool)
  case logOut
  case profile(success: Bool)
  case deleteAccount

  var urlString: String {
    switch self {
    case .signUp:
      return "/users/"
    case .signIn:
      return "/users/sign_in"
    case .logOut:
      return "/users/sign_out"
    case .profile:
      return "/user/profile"
    case .deleteAccount:
      return "/user/delete_account"
    }
  }

  var responseFileName: String {
    switch self {
    case .signUp(let success):
      return success ? "SignUpSuccessfully" : "AuthenticationError"
    case .signIn(let success):
      return success ? "LoginSuccessfully" : "AuthenticationError"
    case .logOut, .deleteAccount:
      return "LogOutSuccessfully"
    case .profile(let success):
      return success ? "GetProfileSuccessfully" : "GetProfileFailure"
    }
  }

  var headers: [String: String]? {
    switch self {
    case .signUp(let success), .signIn(let success):
      if success {
        return [
          HTTPHeader.uid.rawValue: "uid",
          HTTPHeader.client.rawValue: "client",
          HTTPHeader.token.rawValue: "accessToken",
          HTTPHeader.expiry.rawValue: "\(Date.distantFuture.timeIntervalSinceNow)",
          HTTPHeader.contentType.rawValue: "application/json"
        ]
      }
      return nil
    default:
      return nil
    }
  }
}

extension NetworkMocker {
  
  func stub(
    with networkStub: NetworkStub,
    method: HTTPMethod,
    customHeaders: [String: String]? = nil
  ) {
    stub(
      url: networkStub.urlString,
      responseFilename: networkStub.responseFileName,
      method: method,
      customHeaders: customHeaders ?? networkStub.headers
    )
  }
}
