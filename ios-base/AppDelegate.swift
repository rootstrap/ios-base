//
//  AppDelegate.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()

  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Override point for customization after application launch.
    AnalyticsManager.shared.setup()
    
    IQKeyboardManager.shared.enable = true

    let rootVC = AppNavigator.shared.rootViewController
    window?.rootViewController = rootVC

    return true
  }
  
  func unexpectedLogout() {
    UserDataManager.shared.deleteUser()
    SessionManager.shared.deleteSession()
    // Clear any local data if needed
    // Take user to onboarding if needed, do NOT redirect the user
    // if is already in the landing to avoid losing the current VC stack state.
    if window?.rootViewController is HomeViewController {
      AppNavigator.shared.navigate(to: OnboardingRoutes.firstScreen, with: .changeRoot)
    }
  }
}
