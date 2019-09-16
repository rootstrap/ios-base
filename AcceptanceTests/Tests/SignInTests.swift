//
//  SignInTests.swift
//  ios-base
//
//  Created by Rootstrap on 5/15/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import OHHTTPStubs
import KIF
@testable import ios_base_Debug

class SignInTests: KIFTestCase {
  
  let unauthorizedStubPath = OHPathForFile("Unauthorized.json", SignInTests.self)!
  
  override func beforeEach() {
    super.beforeEach()
    
    AppNavigator.shared.pop()

    tester().waitForView(withAccessibilityIdentifier: "StartView")
    tester().tapView(withAccessibilityIdentifier: "GoToSignInButton")
    tester().waitForView(withAccessibilityIdentifier: "SignInView")
  }
  
  override func afterEach() {
    super.afterEach()

    SessionManager.deleteSession()
    AppNavigator.shared.popToRoot()
  }

  override func afterAll() {
    super.afterAll()
    AppNavigator.shared.navigate(
      to: OnboardingRoutes.firstScreen, with: .changeRoot, animated: false
    )
  }

  // MARK: - Tests
  
  func testSignInFormValidation() {
    //Empty form
    checkControl(withID: "SignInButton", enabled: false)
    //Bad email
    tester().enterText(
      "user@email", intoViewWithAccessibilityIdentifier: "EmailTextField"
    )
    tester().enterText("password", intoViewWithAccessibilityIdentifier: "PasswordTextField")
    checkControl(withID: "SignInButton", enabled: false)
    //Good email - Bad password
    tester().clearTextFromView(withAccessibilityIdentifier: "EmailTextField")
    tester().enterText(
      "user@email.com", intoViewWithAccessibilityIdentifier: "EmailTextField"
    )
    tester().clearTextFromView(withAccessibilityIdentifier: "PasswordTextField")
    checkControl(withID: "SignInButton", enabled: false)
  }
  
  func testSignInSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      let signInJSONPath = OHPathForFile("SignInSuccessfully.json", type(of: self))
      return fixture(
        filePath: signInJSONPath!, status: 200, headers: Test.validUserHeaders
      )
    }

    proceedToLogin()
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
    XCTAssertEqual(SessionManager.validSession, true)
    XCTAssertNotNil(UserDataManager.currentUser, "Stored user should NOT be nil.")
    XCTAssertEqual(
      UserDataManager.currentUser!.email,
      "test@test.com", "Stored user data is not correct."
    )
  }
  
  func testSignInFailure() {
    stubUnauthorizedUser()
    
    proceedToLogin()
    modalMessageAppears()
    XCTAssertEqual(SessionManager.validSession, false)
    XCTAssertNil(UserDataManager.currentUser, "Stored user should be nil.")
  }
  
  // MARK: - Helper method
  
  func stubUnauthorizedUser() {
    stub(condition: isPath("/api/v1/users/sign_in")) { _ in
      fixture(
        filePath: self.unauthorizedStubPath, status: 401,
        headers: ["Content-Type": "application/json"]
      ).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
  }
  
  func fillFormCorrectly() {
    tester().enterText(
      "rootstrap@gmail.com", intoViewWithAccessibilityIdentifier: "EmailTextField"
    )
    tester().enterText(
      "123456789", intoViewWithAccessibilityIdentifier: "PasswordTextField"
    )
  }
  
  func proceedToLogin() {
    fillFormCorrectly()
    checkControl(withID: "SignInButton", enabled: true)
    tester().tapView(withAccessibilityIdentifier: "SignInButton")
  }
}
