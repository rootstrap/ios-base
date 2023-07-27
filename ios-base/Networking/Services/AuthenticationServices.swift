//
//  AuthenticationServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit
import RSSwiftNetworking
import RSSwiftNetworkingAlamofire

internal class AuthenticationServices {
  
  enum AuthError: LocalizedError {
    case login
    case signUp
    case logout
    case mapping
    case request
    case userSessionInvalid
    
    var errorDescription: String? {
      switch self {
      case .login:
        return "authError_login".localized
      case .signUp:
        return "authError_signUp".localized
      case .logout:
        return "authError_logout".localized
      case .mapping:
        return "authError_mapping".localized
      case .request:
        return "authError_request".localized
      case .userSessionInvalid:
        return "authError_request".localized
      }
    }
  }
  
  // MARK: - Properties
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"
  
  private let sessionManager: SessionManager
  private let userDataManager: UserDataManager
  private let apiClient: BaseAPIClient
  
  init(
    sessionManager: SessionManager = .shared,
    userDataManager: UserDataManager = .shared,
    apiClient: BaseAPIClient = BaseAPIClient.alamofire
  ) {
    self.sessionManager = sessionManager
    self.userDataManager = userDataManager
    self.apiClient = apiClient
  }
  
  @discardableResult func login(
    email: String,
    password: String
  ) async -> Result<UserData, AuthError> {
    let response: RequestResponse<UserData> = await apiClient.request(
      endpoint: AuthEndpoint.signIn(email: email, password: password)
    )
    switch response.result {
    case .success(let user):
      if
        let user,
        self.saveUserSession(user.data, headers: response.responseHeaders)
      {
        return .success(user)
      } else {
        return .failure(AuthError.mapping)
      }
    case .failure:
      return .failure(AuthError.login)
    }
  }
  
  /// Example Upload via Multipart requests.
  /// TODO: rails base backend not supporting multipart uploads yet
  @discardableResult func signup(
    email: String,
    password: String,
    avatar: UIImage
  ) async -> Result<UserData, AuthError> {
    
    guard let picData = avatar.jpegData(compressionQuality: 0.75) else {
      let pictureDataError = App.error(
        domain: .generic,
        localizedDescription: "Multipart image data could not be constructed"
      )
      return .failure(AuthError.mapping)
    }
    
    // Mixed base64 encoded and multipart images are supported
    // in the [MultipartMedia] array
    // Example: `let image2 = Base64Media(key: "user[image]", data: picData)`
    // Then: media [image, image2]
    let image = MultipartMedia(fileName: "\(email)_image", key: "user[avatar]", data: picData)
    
    let endpoint = AuthEndpoint.signUp(
      email: email,
      password: password,
      passwordConfirmation: password,
      picture: nil
    )
    
    let response: RequestResponse<UserData> = await apiClient.multipartRequest(
      endpoint: endpoint,
      paramsRootKey: "",
      media: [image])
    
    switch response.result {
    case .success(let user):
      if
        let user,
        self.saveUserSession(user.data, headers: response.responseHeaders)
      {
        return .success(user)
      } else {
        return .failure(AuthError.mapping)
      }
    case .failure:
      return .failure(AuthError.signUp)
    }
  }
  
  /// Example method that uploads base64 encoded image.
  @discardableResult func signup(
    email: String,
    password: String,
    avatar64: UIImage
  ) async -> Result<UserData, AuthError> {
    let response: RequestResponse<UserData> = await apiClient.request(
      endpoint: AuthEndpoint.signUp(
        email: email,
        password: password,
        passwordConfirmation: password,
        picture: avatar64.jpegData(compressionQuality: 0.75)
      )
    )
    
    switch response.result {
    case .success(let user):
      if
        let user,
        self.saveUserSession(user.data, headers: response.responseHeaders)
      {
        return .success(user)
      } else {
        return .failure(AuthError.mapping)
      }
    case .failure:
      return .failure(AuthError.signUp)
    }
  }
  
  @discardableResult func logout() async -> Result<Bool, Error> {
    let response: RequestResponse<Network.EmptyResponse> = await apiClient.request(
      endpoint: AuthEndpoint.logout
    )
    switch response.result {
    case .success:
      userDataManager.deleteUser()
      sessionManager.deleteSession()
      return .success(true)
    case .failure:
      return .failure(AuthError.logout)
    }
  }

  @discardableResult func deleteAccount() async -> Result<Void, Error> {
    let response: RequestResponse<Network.EmptyResponse> = await apiClient.request(
      endpoint: AuthEndpoint.deleteAccount
    )
    switch response.result {
    case .success:
      userDataManager.deleteUser()
      sessionManager.deleteSession()
      return .success(())
    case .failure:
      return .failure(AuthError.logout)
    }
  }
  
  func saveUserSession(
    _ user: User?,
    headers: [AnyHashable: Any]
  ) -> Bool {
    userDataManager.currentUser = user
    guard let session = Session(headers: headers) else { return false }
    sessionManager.saveUser(session: session)
    return userDataManager.currentUser != nil && sessionManager.currentSession?.isValid ?? false
  }
}
