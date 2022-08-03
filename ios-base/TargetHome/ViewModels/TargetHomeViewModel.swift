//
//  TargetViewModels.swift
//  ios-base
//
//  Created by Lucas Miotti on 27/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class TargetHomeViewModel {
  
  func logOut() {
    let fbLoginManager = LoginManager()
    fbLoginManager.logOut()
    UserDataManager.deleteUser()
  }
}
