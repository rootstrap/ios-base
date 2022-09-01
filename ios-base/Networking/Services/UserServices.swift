//
//  UserServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import RSSwiftNetworking

internal class UserServices {

  private let apiClient: APIClient

  init(apiClient: APIClient = iOSBaseAPIClient.shared) {
    self.apiClient = apiClient
  }

  func getMyProfile(completion: @escaping (Result<User, Error>) -> Void) {
    apiClient.request(
      endpoint: UserEndpoint.profile
    ) { (result: Result<User?, Error>, _) in
      switch result {
      case .success(let user):
        guard let user = user else {
          let noUserFoundError = App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid user".localized
          )
          completion(.failure(noUserFoundError))
          return
        }

        UserDataManager.currentUser = user
        completion(.success(user))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
