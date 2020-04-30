//
//  XCTestCaseExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
  func waitFor(element: XCUIElement, timeOut: TimeInterval) {
    let exists = NSPredicate(format: "exists == 1")
    
    expectation(for: exists, evaluatedWith: element, handler: nil)
    waitForExpectations(timeout: timeOut, handler: nil)
  }
}
