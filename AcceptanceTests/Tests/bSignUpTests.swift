//
//  SignUpTests.swift
//  swift-base
//
//  Created by TopTier labs on 5/15/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import OHHTTPStubs
import KIF
@testable import swiftbase

class bSignUpTests: KIFTestCase {
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignUpButton")
    tester().waitForView(withAccessibilityIdentifier: "SignUpView")
  }
  
  override func afterEach() {
    super.afterEach()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, !SessionDataManager.checkSession() {
      navigationController.popViewController(animated: true)
    }
  }
  
  override func afterAll() {
    super.afterAll()
    
    SessionDataManager.deleteSessionObject()
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  // MARK: Tests
  
  func test00SignUpEmptyUsernameError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test01SignUpMatchPasswordError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("differentPassword", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test02SignUpEmptyFieldsError() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test03SignUpSuccessfully() {
    stub(condition: isPath("/api/v1/users")) { _ in
      let stubPath = OHPathForFile("SignUpSuccessfully.json", type(of: self))
      return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json", "uid": ""]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("name", intoViewWithAccessibilityIdentifier: "NameTextField")
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
    XCTAssertEqual(SessionDataManager.checkSession(), true)
  }
  
  //MARK: Helper method
  
  func showErrorMessage() {
    tester().waitForView(withAccessibilityLabel: "Error")
    tester().tapView(withAccessibilityLabel: "Ok")
  }
}
