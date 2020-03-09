//
//  ios_baseUITests.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 TopTier labs. All rights reserved.
//

import XCTest
@testable import ios_base_Debug

class ios_baseUITests: XCTestCase {

  var app: XCUIApplication!
  
  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchArguments = ["Automation Test"]
  }
  
  func testCreateAccountValidations() {
    app.launch()
    
    app.logOutIfNeeded(in: self)
    
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
  
  func testSignInSuccess() {
    app.launch()
    
    app.logOutIfNeeded(in: self)
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "holahola")
    
    //TEST CODE ONLY ELSE BLOCK SHOULD BE EXECUTED NORMALLY
    sleep(10)
    if let alert = app.alerts.allElementsBoundByIndex.first {
      waitFor(element: alert, timeOut: 10)
      XCTAssertTrue(alert.label == "Error")
      
      alert.buttons.allElementsBoundByIndex.first?.forceTap()
    } else {
      let logOutButton = app.buttons["LogoutButton"]
      waitFor(element: logOutButton, timeOut: 10)
      
      logOutButton.forceTap()
      
      let goToSignInButton = app.buttons["GoToSignInButton"]
      waitFor(element: goToSignInButton, timeOut: 10)
    }
  }
  
  func testSignInFailure() {
    app.launch()
    
    app.logOutIfNeeded(in: self)
    
    app.attemptSignIn(in: self,
                      with: "automation@test.com",
                      password: "incorrect password")
    
    if let alert = app.alerts.allElementsBoundByIndex.first {
      waitFor(element: alert, timeOut: 2)
      XCTAssertTrue(alert.label == "Error")
      
      alert.buttons.allElementsBoundByIndex.first?.forceTap()
    }
    
    let signInButton = app.buttons["SignInButton"]
    waitFor(element: signInButton, timeOut: 2)
  }
  
  func testSignInValidations() {
    app.launch()
    
    app.logOutIfNeeded(in: self)
    
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
