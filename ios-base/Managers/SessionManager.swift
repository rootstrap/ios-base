//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit

internal class SessionManager: CurrentUserSessionProvider {

  static let shared = SessionManager()

  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  var currentSession: Session? {
    get {
      if
        let data = userDefaults.data(forKey: "ios-base-session"),
        let session = try? JSONDecoder().decode(Session.self, from: data)
      {
        return session
      }
      return nil
    }
    
    set {
      let session = try? JSONEncoder().encode(newValue)
      userDefaults.set(session, forKey: "ios-base-session")
    }
  }
  
  func deleteSession() {
    userDefaults.removeObject(forKey: "ios-base-session")
  }
  
  var validSession: Bool {
    if let session = currentSession, let uid = session.uid,
       let tkn = session.accessToken, let client = session.client {
      return !uid.isEmpty && !tkn.isEmpty && !client.isEmpty
    }
    return false
  }
}
