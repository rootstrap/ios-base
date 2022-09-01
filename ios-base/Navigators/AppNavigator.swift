//
//  AppNavigator.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation

internal class AppNavigator: BaseNavigator {

  static let shared = AppNavigator(isLoggedIn: SessionManager.shared.validSession)

  init(isLoggedIn: Bool) {
    let initialRoute: Route = isLoggedIn
      ? HomeRoutes.home
      : OnboardingRoutes.firstScreen
    super.init(with: initialRoute)
  }

  required init(with route: Route) {
    super.init(with: route)
  }
}
