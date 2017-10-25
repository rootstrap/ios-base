//
//  UserDataManager.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  class func storeUserObject(_ user: User) {
    let defaults = UserDefaults.standard
    defaults.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: "\(targetName)-user")
  }
  
  class func getUserObject() -> User? {
    let defaults = UserDefaults.standard
    
    if let data = defaults.object(forKey: "\(targetName)-user") as? Data {
      let unarc = NSKeyedUnarchiver(forReadingWith: data)
      return unarc.decodeObject(forKey: "root") as? User
    }
    
    return nil
  }
  
  class func deleteUserObject() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "\(targetName)-user")
  }
  
  class func checkSignin() -> Bool {
    return self.getUserObject() != nil
  }
}
