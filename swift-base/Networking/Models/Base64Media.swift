//
//  Base64Media.swift
//  swift-base
//
//  Created by German on 7/7/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import Alamofire

class Base64Media: MultipartMedia {
  var base64: String
  
  override init(key: String, data: Data, type: MimeType = .jpeg) {
    self.base64 = data.asBase64Param(withType: type)
    super.init(key: key, data: data, type: type)
  }
  
  override func embed(inForm multipart: MultipartFormData) {
    APIClient.multipartFormData(multipart, params: base64, rootKey: key)
  }
}
