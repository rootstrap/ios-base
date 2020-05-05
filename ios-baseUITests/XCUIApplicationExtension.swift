//
//  XCUIApplicationExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest

extension XCUIApplication {
  func type(text: String, on fieldName: String, isSecure: Bool = false) {
    let fields = isSecure ? secureTextFields : textFields
    let field = fields[fieldName]
    field.forceTap()
    field.typeText(text)
  }
  
  func clearText(on fieldName: String) {
    let field = textFields[fieldName]
    field.forceTap()
    field.clearText()
  }
  
  func logOutIfNeeded(in testCase: XCTestCase) {
    let logOutButton = buttons["LogoutButton"]
    let goToSignInButton = buttons["GoToSignInButton"]
    
    if logOutButton.exists {
      logOutButton.forceTap()
      testCase.waitFor(element: goToSignInButton, timeOut: 5)
    }
  }
  
  func attemptSignIn(
    in testCase: XCTestCase,
    with email: String,
    password: String
  ) {
    let goToSignInButton = buttons["GoToSignInButton"]
    let toolbarDoneButton = buttons["Toolbar Done Button"]
    
    testCase.waitFor(element: goToSignInButton, timeOut: 2)
    goToSignInButton.forceTap()
    
    let signInButton = buttons["SignInButton"]
    
    testCase.waitFor(element: signInButton, timeOut: 2)
    
    type(text: email, on: "EmailTextField")
    
    toolbarDoneButton.forceTap()
    
    type(text: password, on: "PasswordTextField", isSecure: true)
    
    toolbarDoneButton.forceTap()
    
    signInButton.forceTap()
  }
  
  func attemptSignUp(
    in testCase: XCTestCase,
    email: String,
    password: String
  ) {
    buttons["GoToSignUpButton"].forceTap()
    
    let toolbarDoneButton = buttons["Toolbar Done Button"]
    let signUpButton = buttons["SignUpButton"]
    testCase.waitFor(element: signUpButton, timeOut: 2)
    
    type(text: email, on: "EmailTextField")
    
    toolbarDoneButton.forceTap()
    type(
      text: password,
      on: "PasswordTextField",
      isSecure: true
    )
    XCTAssertFalse(signUpButton.isEnabled)
    
    toolbarDoneButton.forceTap()
    type(
      text: password,
      on: "ConfirmPasswordTextField",
      isSecure: true
    )
    
    toolbarDoneButton.forceTap()
    signUpButton.forceTap()
  }
}
