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
    
    app.buttons["GoToSignUpButton"].tap()
    
    let toolbarDoneButton = app.buttons["Toolbar Done Button"]
    let signUpButton = app.buttons["SignUpButton"]
    waitFor(element: signUpButton, timeOut: 2)
    
    XCTAssertFalse(signUpButton.isEnabled)
    
    app.type(text: "automation@test", on: "EmailTextField")
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.tap()
    app.type(text: "holahola",
             on: "PasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.tap()
    app.type(text: "holahola",
             on: "ConfirmPasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.tap()
    app.type(text: ".com", on: "EmailTextField")
    XCTAssert(signUpButton.isEnabled)
    toolbarDoneButton.tap()
    
    app.type(text: "holahol",
             on: "ConfirmPasswordTextField",
             isSecure: true)
    XCTAssertFalse(signUpButton.isEnabled)
  }
}
