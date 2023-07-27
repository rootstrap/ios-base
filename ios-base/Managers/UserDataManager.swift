//
//  UserDataManager.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  static let shared = UserDataManager()
  
  static let USERKEY = "ios-base-user"
  
  var currentUser: User? {
    get {
      let defaults = UserDefaults.standard
      if
        let data = defaults.data(forKey: UserDataManager.USERKEY),
        let user = try? JSONDecoder().decode(User.self, from: data)
      {
        return user
      }
      return nil
    }
    
    set {
      let user = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(user, forKey: UserDataManager.USERKEY)
    }
  }
  
  func deleteUser() {
    UserDefaults.standard.removeObject(forKey: UserDataManager.USERKEY)
  }
  
  var isUserLogged: Bool {
    currentUser != nil
  }
}
