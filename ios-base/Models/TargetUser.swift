//
//  TargetUser.swift
//  ios-base
//
//  Created by Lucas Miotti on 25/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

struct TargetUser: Codable {
  let id: Int
  let email: String
  let provider: String
  let uid: String
  let firstName: String
  let lastName: String
  let username: String
  let avatar: Avatar
  
  private enum CodingKeys: String, CodingKey {
    case id
    case email
    case provider
    case uid
    case firstName = "first_name"
    case lastName = "last_name"
    case username
    case avatar
  }
}

struct Avatar: Codable {
  let url: String?
  let normal: ImageUrl
  let smallThumb: ImageUrl
  
  private enum CodingKeys: String, CodingKey {
    case url
    case normal
    case smallThumb = "small_thumb"
  }
}

struct ImageUrl: Codable {
  let url: String?
  
  private enum CodingKeys: String, CodingKey {
    case url
  }
}
