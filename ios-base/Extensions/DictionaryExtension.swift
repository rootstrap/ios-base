//
//  DictionaryExtension.swift
//  swift-base
//
//  Created by German on 6/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation

//+ Operator definition for Dictionary types

func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
  var merge = left
  for (k, v) in right {
    merge[k] = v
  }
  return merge
}

func += <K, V> (left: inout [K: V], right: [K: V]) {
  left += right
}
