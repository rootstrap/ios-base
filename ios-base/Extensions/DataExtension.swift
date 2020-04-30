//
//  DataExtension.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/5/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation

//Helper to retrieve the right string value for base64 API uploaders
extension Data {
  func asBase64Param(withType type: MimeType = .jpeg) -> String {
    return "data:\(type.rawValue);base64,\(self.base64EncodedString())"
  }
}
