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
    XCTAssertFalse("german".isEmailFormatted())
    XCTAssertFalse("german@test".isEmailFormatted())
    XCTAssert("german@test.com".isEmailFormatted())
    XCTAssert("german.stabile+2@gmail.com".isEmailFormatted())
  }
}
