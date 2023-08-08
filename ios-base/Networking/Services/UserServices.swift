//
//  UserServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import RSSwiftNetworking
import RSSwiftNetworkingAlamofire

internal class UserServices {
  
  enum UserError: LocalizedError {
    case getMyProfile
    case mapping
    
    var errorDescription: String? {
      switch self {
      case .getMyProfile:
        return "userError_login".localized
      case .mapping:
        return "userError_mapping".localized
      }
    }
  }

  private let userDataManager: UserDataManager
  private let apiClient: BaseAPIClient

  init(
    userDataManager: UserDataManager = .shared,
    apiClient: BaseAPIClient = BaseAPIClient.alamofire
  ) {
    self.userDataManager = userDataManager
    self.apiClient = apiClient
  }
  
  @discardableResult func getMyProfile() async -> Result<UserData, UserError> {
    let response: RequestResponse<UserData> = await apiClient.request(
      endpoint: UserEndpoint.profile
    )
    switch response.result {
    case .success(let user):
      if let user = user {
        userDataManager.currentUser = user.data
        return .success(user)
      } else {
        return .failure(UserError.mapping)
      }
    case .failure:
      let noUserFoundError = App.error(
        domain: .parsing,
        localizedDescription: "Could not parse a valid user".localized
      )
      return .failure(UserError.getMyProfile)
    }
  }
}
