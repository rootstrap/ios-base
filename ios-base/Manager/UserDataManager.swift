//
//  UserDataManager.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  static var currentUser: User? {
    get {
      let defaults = UserDefaults.standard
      
      if let data = defaults.object(forKey: "ios-base-user") as? Data {
        let unarc = NSKeyedUnarchiver(forReadingWith: data)
        return unarc.decodeObject(forKey: "root") as? User
      }
      
      return nil
    }
    
    set {
      let defaults = UserDefaults.standard
      let user = newValue == nil ? nil : NSKeyedArchiver.archivedData(withRootObject: newValue!)
      defaults.set(user, forKey: "ios-base-user")
    }
  }
  
  class func deleteUser() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "ios-base-user")
  }
  
  static var isUserLogged: Bool {
    return currentUser != nil
  }
}
