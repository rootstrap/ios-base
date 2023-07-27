//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

internal class SessionManager: CurrentUserSessionProvider {
  
  var isSessionValidPublisher: AnyPublisher<Bool, Never> {
    currentSessionPublisher.map { $0?.isValid ?? false }.eraseToAnyPublisher()
  }
  
  private var currentSessionPublisher: AnyPublisher<Session?, Never> {
    userDefaults.publisher(for: \.currentSession).eraseToAnyPublisher()
  }
  
  private var subscriptions = Set<AnyCancellable>()
  private let userDefaults: UserDefaults
  
  static let SESSIONKEY = "ios-base-session"
  
  static let shared = SessionManager()
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  private(set) var currentSession: Session? {
    get {
      userDefaults.currentSession
    }
    
    set {
      userDefaults.currentSession = newValue
    }
  }
  
  func deleteSession() {
    currentSession = nil
  }
  
  func saveUser(session: Session) {
    userDefaults.currentSession = session
  }
}

fileprivate extension UserDefaults {
  @objc dynamic var currentSession: Session? {
    get {
      if
        let data = data(forKey: SessionManager.SESSIONKEY),
        let session = try? JSONDecoder().decode(Session.self, from: data)
      {
        return session
      }
      return nil
    }
    set {
      let session = try? JSONEncoder().encode(newValue)
      set(session, forKey: SessionManager.SESSIONKEY)
    }
  }
}
