//
//  StringExtension.swift
//  swift-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation

extension String {
  func length() -> Int {
    return self.characters.count
  }
  
  func isEmailFormatted() -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    return predicate.evaluateWithObject(self)
  }
}
