//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

class HomeViewModel {
  
  func loadUserProfile(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
    UserAPI.getMyProfile({ user in
      success(user.email)
    }, failure: { error in
      failure(error.localizedDescription)
    })
  }
  
  func logoutUser(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
    UserAPI.logout(success, failure: { error in
      failure(error.localizedDescription)
    })
  }
}
