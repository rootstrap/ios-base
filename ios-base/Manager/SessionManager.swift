//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class SessionManager: NSObject {

  static var currentSession: Session? {
    get {
      let defaults = UserDefaults.standard
      if let data = defaults.object(forKey: "ios-base-session") as? Data {
        let unarc = NSKeyedUnarchiver(forReadingWith: data)
        return unarc.decodeObject(forKey: "root") as? Session
      }
      
      return nil
    }
    
    set {
      let defaults = UserDefaults.standard
      let session = newValue == nil ? nil : NSKeyedArchiver.archivedData(withRootObject: session!)
      defaults.set(session, forKey: "ios-base-session")
    }
  }
  
  class func deleteSession() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "ios-base-session")
  }
  
  static var validSession: Bool {
    return currentSession != nil
  }
}
