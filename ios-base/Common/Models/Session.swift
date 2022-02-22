//
//  Session.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation
import RSSwiftNetworking

struct Session: Codable {
  var uid: String?
  var client: String?
  var accessToken: String?
  var expiry: Date?
  
  var isValid: Bool {
    [uid, accessToken, client].allSatisfy { !($0 ?? "").isEmpty }
  }
  
  private enum CodingKeys: String, CodingKey {
    case uid
    case client
    case accessToken = "access-token"
    case expiry
  }

  init(
    uid: String? = nil, client: String? = nil,
    token: String? = nil, expires: Date? = nil
  ) {
    self.uid = uid
    self.client = client
    self.accessToken = token
    self.expiry = expires
  }
  
  init?(headers: [String: String]) {
    var loweredKeysHeaders = headers
    loweredKeysHeaders.lowercaseKeys()
    if let expiryString = loweredKeysHeaders[APIClient.HTTPHeader.expiry.rawValue],
      let expiryNumber = Double(expiryString) {
      expiry = Date(timeIntervalSince1970: expiryNumber)
    }
    uid = loweredKeysHeaders[APIClient.HTTPHeader.uid.rawValue]
    client = loweredKeysHeaders[APIClient.HTTPHeader.client.rawValue]
    accessToken = loweredKeysHeaders[APIClient.HTTPHeader.token.rawValue]
  }
}
