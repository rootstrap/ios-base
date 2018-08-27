//
//  Session.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation

class Session: Codable {
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

  init(uid: String? = nil, client: String? = nil, token: String? = nil, expires: Date? = nil) {
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
  
  //MARK: Codable
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(uid, forKey: .uid)
    try container.encode(client, forKey: .client)
    try container.encode(accessToken, forKey: .accessToken)
    try container.encode(expiry?.timeIntervalSince1970, forKey: .expiry)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    uid = try container.decode(String.self, forKey: .uid)
    client = try container.decode(String.self, forKey: .client)
    accessToken = try container.decode(String.self, forKey: .accessToken)
    do {
      let value = try container.decode(Double.self, forKey: .expiry)
      expiry = Date(timeIntervalSince1970: value)
    } catch {
      //Do nothing, expiry can be nil
    }
  }
}
