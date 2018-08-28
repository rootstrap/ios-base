//
//  SignUpTests.swift
//  ios-base
//
//  Created by Rootstrap on 5/15/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import OHHTTPStubs
import KIF
@testable import ios_base

class SignUpTests: KIFTestCase {
  
  let unauthorizedStubPath = OHPathForFile("Unauthorized.json", SignUpTests.self)!
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignUpButton")
    tester().waitForView(withAccessibilityIdentifier: "SignUpView")
  }
  
  override func afterEach() {
    super.afterEach()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, !SessionManager.validSession {
      navigationController.popViewController(animated: true)
    }
  }
  
  override func afterAll() {
    super.afterAll()
    
    SessionManager.deleteSession()
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
    
    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
  }
  
  // MARK: - Tests
  
  func testSignUpFormEmailFormatting() {
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    checkControl(withID: "SignUpButton", enabled: false)
    tester().enterText("notan@email", intoViewWithAccessibilityIdentifier: "EmailTextField")
    checkControl(withID: "SignUpButton", enabled: false)
  }
  
  func testSignUpFormUnmatchingPassword() {
    tester().enterText("user@email.com", intoViewWithAccessibilityIdentifier: "EmailTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("differentPassword", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
    checkControl(withID: "SignUpButton", enabled: false)
  }
  
  func testSignUpEmptyFieldsError() {
    checkControl(withID: "SignUpButton", enabled: false)
  }
  
  func testSignUpSuccessfully() {
    stub(condition: isPath("/api/v1/users")) { _ in
      let signUpJSONPath = OHPathForFile("SignUpSuccessfully.json", type(of: self))
      return fixture(filePath: signUpJSONPath!, status: 200, headers: Test.validUserHeaders)
    }
    
    proceedToSignUp()
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
    XCTAssertEqual(SessionManager.validSession, true)
    XCTAssertNotNil(UserDataManager.currentUser, "Stored user should NOT be nil.")
    XCTAssertEqual(UserDataManager.currentUser!.email, "test@test.com", "Stored user data is not correct.")
  }
  
  func testSignUpFailure() {
    stubUnauthorizedNewUser()
    
    proceedToSignUp()
    modalMessageAppears()
    XCTAssertEqual(SessionManager.validSession, false)
    XCTAssertNil(UserDataManager.currentUser, "Stored user should be nil.")
  }
  
  // MARK: - Helper method
  
  func stubUnauthorizedNewUser() {
    stub(condition: isPath("/api/v1/users")) { _ in
      return fixture(filePath: self.unauthorizedStubPath, status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
  }
  
  func fillFormCorrectly() {
    tester().enterText("user@email.com", intoViewWithAccessibilityIdentifier: "EmailTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "ConfirmPasswordTextField")
  }
  
  func proceedToSignUp() {
    fillFormCorrectly()
    checkControl(withID: "SignUpButton", enabled: true)
    tester().tapView(withAccessibilityIdentifier: "SignUpButton")
  }
}
