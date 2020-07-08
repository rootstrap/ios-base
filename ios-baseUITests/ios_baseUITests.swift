//
//  ios_baseUITests.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest
@testable import ios_base_Debug

class ios_baseUITests: XCTestCase {

  var app: XCUIApplication!
  
  let networkMocker = NetworkMocker()
  
  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchArguments = ["Automation Test"]
    networkMocker.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    networkMocker.tearDown()
  }
  
  func testCreateAccountValidations() {
    app.launch()
    
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
    app.launch()
    
    networkMocker.stubSignUp()
    
    app.attemptSignUp(
      in: self,
      email: "automation@test.com",
      password: "holahola"
    )
    
    networkMocker.stubGetProfile()
    let getMyProfile = app.buttons["GetMyProfileButton"]
    waitFor(element: getMyProfile, timeOut: 10)
    getMyProfile.tap()
    
    sleep(1)
    if let alert = app.alerts.allElementsBoundByIndex.first {
      waitFor(element: alert, timeOut: 10)
      
      alert.buttons.allElementsBoundByIndex.first?.tap()
    }
    
    let logOutButton = app.buttons["LogoutButton"]
    waitFor(element: logOutButton, timeOut: 5)
    
    networkMocker.stubLogOut()
    
    logOutButton.tap()
  }
  
  func testSignInSuccess() {
    app.launch()
    
    networkMocker.stubLogIn()
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "holahola")
    
    let logOutButton = app.buttons["LogoutButton"]
    waitFor(element: logOutButton, timeOut: 10)
    
    networkMocker.stubLogOut()
    logOutButton.forceTap()
    
    let goToSignInButton = app.buttons["GoToSignInButton"]
    waitFor(element: goToSignInButton, timeOut: 10)
  }
  
  func testSignInFailure() {
    app.launch()
    
    networkMocker.stubLogIn(shouldSucceed: false)
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "incorrect password")
    
    if let alert = app.alerts.allElementsBoundByIndex.first {
      waitFor(element: alert, timeOut: 2)
      
      alert.buttons.allElementsBoundByIndex.first?.forceTap()
    }
    
    let signInButton = app.buttons["SignInButton"]
    waitFor(element: signInButton, timeOut: 2)
  }
  
  func testSignInValidations() {
    app.launch()
    
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
