//
//  TargetAuthServices.swift
//  ios-base
//
//  Created by Lucas Miotti on 25/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

class TargetAuthServices {
    
  class func signIn(
    email: String,
    password: String,
    completion: @escaping (Result<TargetUser, Error>) -> Void
  ) {
    let request = BaseAPIClient.default.request(
      endpoint: TargetAuthEndpoint.signIn(email: email, password: password)
    ) { (result: Result<TargetUser?, Error>, responseHeaders: [String: String]) in
      switch result {
      case .success(let user):
        completion(.success(user!))
      case .failure(let error):
          completion(.failure(error))
      }
    }
    print(request)
  }
  
  class func register(
    username: String,
    email: String,
    gender: String,
    password: String,
    passwordConfirmation: String,
    completion: @escaping (Result<TargetUser, Error>) -> Void
  ) {
    BaseAPIClient.default.request(
      endpoint: TargetAuthEndpoint.register(
        username: username,
        email: email,
        gender: gender,
        password: password,
        passwordConfirmation: passwordConfirmation
      )
    ) { (result: Result<TargetUser?, Error>, responseHeaders: [String: String]) in
      switch result {
      case .success(let user):
        completion(.success(user!))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
