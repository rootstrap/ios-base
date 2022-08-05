//
//  TargetAuthServices.swift
//  ios-base
//
//  Created by Lucas Miotti on 25/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import Moya

class TargetAuthServices {
    
  class func signIn(
    email: String,
    password: String,
    completion: @escaping (Result<TargetUser, Error>) -> Void
  ) {
    let provider = MoyaProvider<TargetAuthEndpoint>()
    provider.request(.signIn(email: email, password: password)) { result in
      switch result {
      case .success(let response):
        do {
          let value = try JSONDecoder().decode(
            DataResponse<TargetUser>.self,
            from: response.data
          )
          completion(.success(value.data))
        } catch let error {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  class func register(
    username: String,
    email: String,
    gender: String,
    password: String,
    passwordConfirmation: String,
    completion: @escaping (Result<TargetUser, Error>) -> Void
  ) {
    let provider = MoyaProvider<TargetAuthEndpoint>()
    provider.request(.register(
        username: username,
        email: email,
        gender: gender,
        password: password,
        passwordConfirmation: passwordConfirmation
      )) { result in
        switch result {
        case .success(let response):
          do {
            let value = try JSONDecoder().decode(
              TargetUser.self,
              from: response.data
            )
            completion(.success(value))
          } catch let error {
            completion(.failure(error))
          }
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  class func authWithFacebook(
    accessToken: String,
    completion: @escaping (Result<TargetUser, Error>) -> Void
  ) {
    let provider = MoyaProvider<TargetAuthEndpoint>()
    provider.request(
      .authWithFacebook(accessToken: accessToken
    )) { result in
      switch result {
      case .success(let response):
        do {
          let value = try JSONDecoder().decode(
            TargetUser.self,
            from: response.data
          )
          completion(.success(value))
        } catch let error {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

struct DataResponse<T: Codable>: Codable {
  var data: T
  
  private enum CodingKeys: String, CodingKey {
    case data
  }
}
