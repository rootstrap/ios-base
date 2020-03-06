//
//  XCUIApplicationExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
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
}
