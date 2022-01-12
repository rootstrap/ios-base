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

  enum AuthError: Error {
    case userSessionInvalid
  }
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"
  
  class func login(
    email: String,
    password: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    BaseAPIClient.default.request(
      endpoint: AuthEndpoint.signIn(email: email, password: password)
    ) { (result: Result<User?, Error>, responseHeaders: [String: String]) in
      switch result {
      case .success(let user):
        if saveUserSession(user, headers: responseHeaders) {
          completion(.success(()))
        } else {
          completion(.failure(AuthError.userSessionInvalid))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /// Example Upload via Multipart requests.
  /// TODO: rails base backend not supporting multipart uploads yet
  class func signup(
    email: String,
    password: String,
    avatar: UIImage,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    guard let picData = avatar.jpegData(compressionQuality: 0.75) else {
      let pictureDataError = App.error(
        domain: .generic,
        localizedDescription: "Multipart image data could not be constructed"
      )
      completion(.failure(pictureDataError))
      return
    }
    
    // Mixed base64 encoded and multipart images are supported
    // in the [MultipartMedia] array
    // Example: `let image2 = Base64Media(key: "user[image]", data: picData)`
    // Then: media [image, image2]
    let image = MultipartMedia(key: "user[avatar]", data: picData)

    let endpoint = AuthEndpoint.signUp(
      email: email,
      password: password,
      passwordConfirmation: password,
      picture: nil
    )

    BaseAPIClient.default.multipartRequest(
      endpoint: endpoint,
      paramsRootKey: "",
      media: [image]
    ) { (result: Result<User?, Error>, responseHeaders: [String: String]) in
      switch result {
      case .success(let user):
        if saveUserSession(user, headers: responseHeaders), let user = user {
          completion(.success(user))
        } else {
          completion(.failure(AuthError.userSessionInvalid))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /// Example method that uploads base64 encoded image.
  class func signup(
    email: String,
    password: String,
    avatar64: UIImage,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    BaseAPIClient.default.request(
      endpoint: AuthEndpoint.signUp(
        email: email,
        password: password,
        passwordConfirmation: password,
        picture: avatar64.jpegData(compressionQuality: 0.75)
      )
    ) { (result: Result<User?, Error>, responseHeaders) in
      switch result {
      case .success(let user):
        if saveUserSession(user, headers: responseHeaders), let user = user {
          completion(.success(user))
        } else {
          completion(.failure(AuthError.userSessionInvalid))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  class func logout(completion: @escaping (Result<Void, Error>) -> Void) {
    BaseAPIClient.default.request(
      endpoint: AuthEndpoint.logout
    ) { (result: Result<EmptyResponse?, Error>, _) in
      switch result {
      case .success:
        UserDataManager.deleteUser()
        SessionManager.deleteSession()
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  class func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
    BaseAPIClient.default.request(
      endpoint: AuthEndpoint.deleteAccount
    ) { (result: Result<EmptyResponse?, Error>, _) in
      switch result {
      case .success:
        UserDataManager.deleteUser()
        SessionManager.deleteSession()
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  fileprivate class func saveUserSession(
    _ user: User?,
    headers: [String: String]
  ) -> Bool {
    UserDataManager.currentUser = user
    SessionManager.currentSession = Session(headers: headers)

    return UserDataManager.currentUser != nil && SessionManager.validSession
  }
}
