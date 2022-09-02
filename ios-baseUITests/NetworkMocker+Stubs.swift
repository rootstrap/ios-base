//
//  NetworkMockerExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 6/30/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation

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
}

extension NetworkMocker {
  
  func stub(with networkStub: NetworkStub, method: HTTPMethod) {
    stub(
      url: networkStub.urlString,
      responseFilename: networkStub.responseFileName,
      method: method
    )
  }
}
