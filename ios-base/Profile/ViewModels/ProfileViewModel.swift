//
//  ProfileViewModel.swift
//  ios-base
//
//  Created by Lucas Miotti on 03/08/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class ProfileViewModel {
  
  func logOut() {
    let fbLoginManager = LoginManager()
    fbLoginManager.logOut()
    UserDataManager.deleteUser()
  }
}
