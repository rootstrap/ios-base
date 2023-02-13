//
//  ios_baseUITests.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest

class ios_baseUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  private var networkMocker: NetworkMocker!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    app = XCUIApplication()
    app.launchArguments = ["Automation Test"]
    app.launch()

    networkMocker = NetworkMocker()
    try networkMocker.setUp()
    networkMocker.stub(with: .logOut, method: .DELETE)
    app.logOutIfNeeded(in: self)
  }
  
  override func tearDown() {
    super.tearDown()
    networkMocker.tearDown()
  }
  
  func testCreateAccountValidations() {
    app.buttons["GoToSignUpButton"].forceTap()
    
    let toolbarDoneButton = app.buttons["Toolbar Done Button"]
    let signUpButton = app.buttons["SignUpButton"]
    waitFor(element: signUpButton, timeOut: 2)
    
    XCTAssertFalse(signUpButton.isEnabled)
    
    app.type(text: "automation@test", on: "EmailTextField")
    
    toolbarDoneButton.forceTap()
    app.type(text: "holahola",
             on: "PasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.forceTap()
    app.type(text: "holahola",
             on: "ConfirmPasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.forceTap()
    app.type(text: ".com", on: "EmailTextField")
    XCTAssert(signUpButton.isEnabled)
    toolbarDoneButton.forceTap()
    
    app.type(text: "holahol",
             on: "ConfirmPasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
  }
  
  func testAccountCreation() {
    networkMocker.stub(with: .signUp(success: true), method: .POST)
    
    app.attemptSignUp(
      in: self,
      email: "automation@test.com",
      password: "holahola"
    )
    
    networkMocker.stub(with: .profile(success: true), method: .GET)
    let getMyProfile = app.buttons["GetMyProfileButton"]
    waitFor(element: getMyProfile, timeOut: 10)
    getMyProfile.tap()
    
    sleep(1)
    if let alert = app.alerts.allElementsBoundByIndex.first {
      waitFor(element: alert, timeOut: 10)
      
      alert.buttons.allElementsBoundByIndex.first?.tap()
    }
  }
  
  func testSignInSuccess() {
    networkMocker.stub(with: .signIn(success: true), method: .POST)
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "holahola")
    
    let logOutButton = app.buttons["LogoutButton"]
    waitFor(element: logOutButton, timeOut: 10)
  }
  
  func testSignInFailure() {
    networkMocker.stub(with: .signIn(success: false), method: .POST)
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "incorrect password")
    
    guard let alert = app.alerts.allElementsBoundByIndex.first else {
      return XCTFail("An error alert is expected to appear on Sign In failure")
    }
    alert.buttons.allElementsBoundByIndex.first?.forceTap()
  }
  
  func testSignInValidations() {
    app.buttons["GoToSignInButton"].forceTap()
    
    let toolbarDoneButton = app.buttons["Toolbar Done Button"]
    let signInButton = app.buttons["SignInButton"]
    
    waitFor(element: signInButton, timeOut: 2)
    
    XCTAssertFalse(signInButton.isEnabled)
    
    app.type(text: "automation@test", on: "EmailTextField")
    
    toolbarDoneButton.forceTap()
    app.type(text: "holahola",
             on: "PasswordTextField",
             isSecure: true)
              
    XCTAssertFalse(signInButton.isEnabled)
    
    toolbarDoneButton.forceTap()
    app.type(text: ".com", on: "EmailTextField")
    
    XCTAssert(signInButton.isEnabled)
  }
}
