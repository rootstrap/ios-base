//
//  KIFExtensions.swift
//  ios-base
//
//  Created by Rootstrap on 5/4/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import KIF

extension KIFTestActorDelegate {
  func tester(file: String = #file, line: Int = #line) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }
  func system(file: String = #file, line: Int = #line) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
  
  func checkControl(withID identifier: String, enabled: Bool) {
    let control = tester().waitForView(
      withAccessibilityIdentifier: identifier
    ) as? UIControl
    XCTAssert(control?.isEnabled == enabled)
  }
  
  func modalMessageAppears(
    withLabel label: String = "Error", defaultOptionLabel: String = "Ok"
  ) {
    tester().waitForView(withAccessibilityLabel: label)
    tester().tapView(withAccessibilityLabel: defaultOptionLabel)
  }
}
