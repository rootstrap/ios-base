//
//  LogoutTests.swift
//  swift-base
//
//  Created by TopTier labs on 5/16/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import KIF
import OHHTTPStubs

class LogoutTests: KIFTestCase {
    
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignInButton")
    tester().waitForView(withAccessibilityIdentifier: "SignInView")
  }
  
  override func afterEach() {
    super.afterEach()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popViewController(animated: true)
    }
  }
  
  // MARK: Tests
  
  func testLogoutSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_out")) { _ in
      return fixture(filePath: "", status: 200, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "LogoutButton")
  }
}
