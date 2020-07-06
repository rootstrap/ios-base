//
//  Session.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation

struct Session: Codable {
  var uid: String?
  var client: String?
  var accessToken: String?
  var expiry: Date?
  
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
  
  init?(headers: [String: Any]) {
    var loweredHeaders = headers
    loweredHeaders.lowercaseKeys()
    guard let stringHeaders = loweredHeaders as? [String: String] else {
      return nil
    }
    if let expiryString = stringHeaders[APIClient.HTTPHeader.expiry.rawValue],
      let expiryNumber = Double(expiryString) {
      expiry = Date(timeIntervalSince1970: expiryNumber)
    }
    uid = stringHeaders[APIClient.HTTPHeader.uid.rawValue]
    client = stringHeaders[APIClient.HTTPHeader.client.rawValue]
    accessToken = stringHeaders[APIClient.HTTPHeader.token.rawValue]
  }
}
