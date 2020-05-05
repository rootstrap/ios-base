//
//  StringExtensionUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 TopTier labs. All rights reserved.
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
}
