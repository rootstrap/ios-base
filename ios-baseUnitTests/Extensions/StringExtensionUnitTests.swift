//
//  StringExtensionUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest
@testable import ios_base_Debug

class StringExtensionUnitTests: XCTestCase {
  func testEmailValidation() {
    XCTAssertFalse("username".isEmailFormatted())
    XCTAssertFalse("username@test".isEmailFormatted())
    XCTAssert("username@test.com".isEmailFormatted())
    XCTAssert("username.alias+2@gmail.com".isEmailFormatted())
  }
  
  func testAlphanumeric() {
    XCTAssertFalse("123598 sdg asd".isAlphanumericWithNoSpaces)
    XCTAssert("1231234314".isAlphanumericWithNoSpaces)
    XCTAssert("asdgasdg".isAlphanumericWithNoSpaces)
    XCTAssert("asdgasd28352".isAlphanumericWithNoSpaces)
  }
  
  func testHasNumbers() {
    XCTAssertFalse("asdgasdfgkjasf ".hasNumbers)
    XCTAssertFalse("$#^&@".hasNumbers)
    XCTAssert("asd235".hasNumbers)
    XCTAssert("124".hasNumbers)
  }
  
  func testHasPunctuation() {
    XCTAssertFalse("asgfasfdhg123".hasPunctuationCharacters)
    XCTAssert("asdg,asd !".hasPunctuationCharacters)
  }
}
