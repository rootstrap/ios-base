//
//  UserServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

class UserServices {
  
  class func getMyProfile(completion: @escaping (Result<User, Error>) -> Void) {
    BaseAPIClient.default.request(
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
