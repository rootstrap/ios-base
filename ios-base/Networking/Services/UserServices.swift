//
//  UserServices.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

class UserServices {
  
  class func getMyProfile(
    success: @escaping (_ user: User) -> Void,
    failure: @escaping (_ error: Error) -> Void
  ) {
    APIClient.request(
      .get,
      url: "/user/profile",
      success: { response, _ in
        guard
          let userDictionary = response["user"] as? [String: Any],
          let user = User(dictionary: userDictionary) 
        else {
          failure(App.error(
            domain: .parsing,
            localizedDescription: "Could not parse a valid user".localized
          ))
          return 
        }
        
        UserDataManager.currentUser = user
        success(user)
      },
      failure: failure
    )
  }
}
