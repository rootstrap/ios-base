//
//  Media.swift
//  swift-base
//
//  Created by TopTier labs on 1/18/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation

struct Media {
  let mediaData: Data
  let mediaKey: String
  let mediaType: String
  
  init(data: Data, key: String, type: String) {
    mediaData = data
    mediaKey = key
    mediaType = type
  }
}
