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
}
