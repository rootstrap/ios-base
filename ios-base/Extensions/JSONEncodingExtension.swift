//
//  JSONEncodingExtension.swift
//  ios-base
//
//  Created by German on 5/15/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation

extension JSONDecoder {
  
  func decode<T>(
    _ type: T.Type, from dictionary: [String: Any]
  ) throws -> T where T: Decodable {
    let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
    return try decode(T.self, from: data ?? Data())
  }
}
