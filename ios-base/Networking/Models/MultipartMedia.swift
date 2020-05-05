//
//  MultipartMedia.swift
//  ios-base
//
//  Created by German on 7/7/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import Foundation
import Alamofire

//Basic media MIME types, add more if needed.
enum MimeType: String {
  case jpeg = "image/jpeg"
  case bmp = "image/bmp"
  case png = "image/png"
  
  case mov = "video/quicktime"
  case mpeg = "video/mpeg"
  case avi = "video/avi"
  case json = "application/json"
  
  func fileExtension() -> String {
    switch self {
    case .bmp: return ".bmp"
    case .png: return ".png"
    case .mov: return ".mov"
    case .mpeg: return ".mpeg"
    case .avi: return ".avi"
    case .json: return ".json"
    default: return ".jpg"
    }
  }
}

class MultipartMedia {
  var key: String
  var data: Data
  var type: MimeType
  var toFile: String {
    return key.validFilename + type.fileExtension()
  }
  
  init(key: String, data: Data, type: MimeType = .jpeg) {
    self.key = key
    self.data = data
    self.type = type
  }
  
  func embed(inForm multipart: MultipartFormData) {
    multipart.append(data, withName: key, fileName: toFile, mimeType: type.rawValue)
  }
}
