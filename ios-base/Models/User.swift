//
//  User.swift
//  ios-base
//
//  Created by Rootstrap on 1/18/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import Foundation

class User: Codable {
  var id: String
  var username: String
  var email: String
  var image: URL?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case username
    case email
    case image = "profile_picture"
  }
  
  init(id: String, username: String = "", email: String, image: String = "") {
    self.id = id
    self.username = username
    self.email = email
    self.image = URL(string: image)
  }
  
  //MARK: Codable

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(username, forKey: .username)
    try container.encode(email, forKey: .email)
    try container.encode(image?.absoluteString, forKey: .image)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      id = try container.decode(String.self, forKey: .id)
    } catch {
      id = String(try container.decode(Int.self, forKey: .id))
    }
    username = try container.decode(String.self, forKey: .username)
    email = try container.decode(String.self, forKey: .email)
    image = URL(string: try container.decodeIfPresent(String.self, forKey: .image) ?? "")
  }
}
