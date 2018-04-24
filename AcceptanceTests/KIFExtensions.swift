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
}
