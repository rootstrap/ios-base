//
//  UserDataManager.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  var sessionToken: String?
  
  class func store(sessionToken: String) {
    let defaults = UserDefaults.standard
    defaults.set(sessionToken, forKey: "sessionToken")
  }
  
  class func getSessionToken() -> String? {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: "sessionToken") as? String
  }
  
}
