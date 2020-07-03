//
//  AnalyticsManager.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/11/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
/**
 Base component in charge of logging events on the application.
 The goal of this class is to act as a proxy
 between the app and all the analytics services that are integrated.
 Broadcast every event to all of it associated services.
*/
class AnalyticsManager: AnalyticsService {
  /**
    List of services that will be notified.
    You can either customize this class and add new ones,
    or subclass it and override the variable.
   */
  open var services: [AnalyticsService] = [FirebaseAnalyticsService()]

  static let shared = AnalyticsManager()

  public func setup() {
    services.forEach { $0.setup() }
  }

  public func identifyUser(with userId: String) {
    services.forEach { $0.identifyUser(with: userId) }
  }

  public func log(event: AnalyticsEvent) {
    services.forEach { $0.log(event: event) }
  }
  
  func reset() {
    services.forEach { $0.reset() }
  }
}
