//
//  XCUIElementExtension.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 2/13/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest

extension XCUIElement {
  
  func clearText(text: String? = nil) {
    guard let stringValue = value as? String ?? text else {
      return
    }
    
    tap()
    let deleteString =
      stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
    typeText(deleteString)
  }
  
  func forceTap() {
    if isHittable {
      tap()
    } else {
      let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
      coordinate.tap()
    }
  }
}
