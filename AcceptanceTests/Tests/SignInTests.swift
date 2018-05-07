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

class SignInTests: KIFTestCase {
  
  let unauthorizedStubPath = OHPathForFile("Unauthorized.json", SignInTests.self)!
  
  override func beforeEach() {
    super.beforeEach()

    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popViewController(animated: true)
    }
    
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignInButton")
    tester().waitForView(withAccessibilityIdentifier: "SignInView")
  }
  
  override func afterEach() {
    super.afterEach()

    SessionManager.deleteSession()
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  override func afterAll() {
    super.afterAll()
    
    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
  }
  
  // MARK: - Tests
  
  func testSignInEmptyPasswordError() {
    stubUnauthorizedUser()
    
    tester().enterText("username", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionManager.validSession, false)
  }
  
  func testSignInEmptyUsernameError() {
    stubUnauthorizedUser()

    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionManager.validSession, false)
  }

  func testSignInEmptyFieldsError() {
   stubUnauthorizedUser()

    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    showErrorMessage()
    XCTAssertEqual(SessionManager.validSession, false)
  }
  
  func testSignInSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      let signInJSONPath = OHPathForFile("SignInSuccessfully.json", type(of: self))
      return fixture(filePath: signInJSONPath!, status: 200, headers: Test.validUserHeaders)
    }

    tester().enterText("rootstrap@gmail.com", intoViewWithAccessibilityIdentifier: "UsernameTextField")
    tester().enterText("123456789", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
    XCTAssertEqual(SessionManager.validSession, true)
    XCTAssertNotNil(UserDataManager.currentUser, "Stored user should NOT be nil.")
    XCTAssertEqual(UserDataManager.currentUser!.email, "test@test.com", "Stored user data is not correct.")
  }
  
  // MARK: - Helper method
  
  func showErrorMessage() {
    tester().waitForView(withAccessibilityLabel: "Error")
    tester().tapView(withAccessibilityLabel: "Ok")
  }
  
  func stubUnauthorizedUser() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      return fixture(filePath: self.unauthorizedStubPath, status: 401, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
  }
}
