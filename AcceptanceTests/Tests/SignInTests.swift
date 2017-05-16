//
//  SignInTests.swift
//  swift-base
//
//  Created by TopTier labs on 5/15/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import OHHTTPStubs
import KIF

class SignInTests: KIFTestCase {
  
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
  
  func testSignInSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      let stubPath = OHPathForFile("SignInSuccessfully.json", type(of: self))
      return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
  }
  
  func testSignInEmptyPasswordError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
  }
  
  func testSignInEmptyUsernameError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
  }
  
  func testSignInEmptyFieldsError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
  }
}
