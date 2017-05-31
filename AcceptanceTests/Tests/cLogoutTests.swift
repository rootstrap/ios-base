//
//  LogoutTests.swift
//  swift-base
//
//  Created by TopTier labs on 5/16/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import KIF
import OHHTTPStubs
@testable import swiftbase

class cLogoutTests: KIFTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    
    SessionDataManager.storeSessionObject(Session()) //Simulates the login
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
      let vc = navigationController.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
      navigationController.pushViewController(vc, animated: true)
    }
  }
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
  }
  
  override func afterAll() {
    super.afterAll()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  // MARK: Tests
  
  func test00LogoutSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_out")) { _ in
      return fixture(filePath: "", status: 200, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "LogoutButton")
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
}
