//
//  DictionaryExtension.swift
//  ios-base
//
//  Created by German on 6/26/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import Foundation

//+ Operator definition for Dictionary types

func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
  var merge = left
  for (key, value) in right {
    merge[key] = value
  }
  return merge
}

// swiftlint:disable shorthand_operator
func += <K, V> (left: inout [K: V], right: [K: V]) {
  left = left + right
}
// swiftlint:enable shorthand_operator

extension Dictionary where Key: ExpressibleByStringLiteral {
  
  mutating func lowercaseKeys() {
    for key in self.keys {
      if let loweredKey = String(describing: key).lowercased() as? Key {
        self[loweredKey] = self.removeValue(forKey: key)
      }
    }
  }
}
