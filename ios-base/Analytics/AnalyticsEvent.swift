//
//  AnalyticsEvent.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/11/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation

/**
 Protocol that defines the minimum attributes that an AnalyticsEvent should have.
 The AnalyticsService is in charge of parsing these events and logging
 them to a specific analytics platform.
 */
protocol AnalyticsEvent {
  /// The event name, usually used to identify itself.
  var name: String { get }
  /// Payload sent to the analytics service as extra information for the event.
  var parameters: [String: Any] { get }
}

/**
 Enums are a nice way of grouping events semantically.
 For example you could have enums for AuthEvents, ProfileEvents, SearchEvents, etc.
 Any data structure that conforms to the AnalyticsEvent protocol will work though.
*/
enum Event: AnalyticsEvent {
  case login
  case registerSuccess(email: String)

  public var name: String {
    switch self {
    case .login:
      return "login"
    case .registerSuccess:
      return "register_success"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .registerSuccess(let email):
      return ["user_email": email]
    default:
      return [:]
    }
  }
}
