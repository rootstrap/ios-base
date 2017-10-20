//
//  UserDataManager.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  class func storeUserObject(_ user: User) {
    let defaults = UserDefaults.standard
    defaults.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: "seatmate-user")
  }
  
  class func getUserObject() -> User? {
    let defaults = UserDefaults.standard
    
    if let data = defaults.object(forKey: "seatmate-user") as? Data {
      let unarc = NSKeyedUnarchiver(forReadingWith: data)
      return unarc.decodeObject(forKey: "root") as? User
    }
    
    return nil
  }
  
  class func deleteUserObject() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "seatmate-user")
  }
  
  class func checkSignin() -> Bool {
    return self.getUserObject() != nil
  }
}
