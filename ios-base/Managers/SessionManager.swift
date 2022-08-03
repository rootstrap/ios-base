//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit

class SessionManager: NSObject {

  static var currentSession: TargetUser? {
    get {
      if
        let data = UserDefaults.standard.data(forKey: "ios-base-session"),
        let session = try? JSONDecoder().decode(TargetUser.self, from: data)
      {
        return session
      }
      return nil
    }
    
    set {
      let session = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(session, forKey: "ios-base-session")
    }
  }
  
  class func deleteSession() {
    UserDefaults.standard.removeObject(forKey: "ios-base-session")
  }
  
  static var validSession: Bool {
    if let session = currentSession {
      return !session.email.isEmpty
    }
    return false
  }
}
