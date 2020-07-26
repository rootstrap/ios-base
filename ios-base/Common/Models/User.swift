//
//  User.swift
//  ios-base
//
//  Created by Rootstrap on 1/18/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import Foundation

struct User: Codable {
  var id: Int
  var username: String
  var email: String
  var image: URL?

  private enum CodingKeys: String, CodingKey {
    case id
    case username
    case email
    case image = "profile_picture"
  }
    
  init?(dictionary: [String: Any]) {
    guard
      let id = dictionary[CodingKeys.id.rawValue] as? Int,
      let username = dictionary[CodingKeys.username.rawValue] as? String,
      let email = dictionary[CodingKeys.email.rawValue] as? String
    else {
      return nil
    }
      
    self.id = id
    self.username = username
    self.email = email
    self.image = URL(string: dictionary[CodingKeys.image.rawValue] as? String ?? "")
  }
}
