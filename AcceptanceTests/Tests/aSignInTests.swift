//
//  SignInTests.swift
//  ios-base
//
//  Created by Rootstrap on 5/15/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import OHHTTPStubs
import KIF
@testable import ios_base

class aSignInTests: KIFTestCase {
  
  override func beforeEach() {
    super.beforeEach()

    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popViewController(animated: true)
    }
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignInButton")
    tester().waitForView(withAccessibilityIdentifier: "SignInView")
  }
  
  override func afterAll() {
    super.afterAll()
    
    SessionDataManager.deleteSessionObject()
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
    
    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
  }
  
  // MARK: Tests
  
  func test00SignInEmptyPasswordError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test01SignInEmptyUsernameError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test02SignInEmptyFieldsError() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: "", status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionDataManager.checkSession(), false)
  }
  
  func test03SignInSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      let stubPath = OHPathForFile("SignInSuccessfully.json", type(of: self))
      return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json", "uid": ""]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
    XCTAssertEqual(SessionDataManager.checkSession(), true)
  }
  
  //MARK: Helper method
  
  func showErrorMessage() {
    tester().waitForView(withAccessibilityLabel: "Error")
    tester().tapView(withAccessibilityLabel: "Ok")
  }
}
