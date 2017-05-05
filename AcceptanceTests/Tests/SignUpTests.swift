//
//  SignUpTests.swift
//  swift-base
//
//  Created by TopTier labs on 5/15/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import OHHTTPStubs
import KIF

class SignUpTests: KIFTestCase {
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignUpButton")
    tester().waitForView(withAccessibilityIdentifier: "SignUpView")
  }
  
  override func afterEach() {
    super.afterEach()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popViewController(animated: true)
    }
  }
  
  // MARK: Tests
  
  func testSignUpSuccessfully() {
    stub(condition: isPath("/api/v1/users")) { _ in
      let stubPath = OHPathForFile("SignUpSuccessfully.json", type(of: self))
      return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
  }
  
  func testSignUpEmptyUsernameError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
  }
  
  func testSignUpMatchPasswordError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("differentPassword", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
  }
  
  func testSignUpEmptyFieldsError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
  }
}
