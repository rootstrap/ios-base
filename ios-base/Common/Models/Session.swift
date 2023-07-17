//
//  Session.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation
import RSSwiftNetworking
import RSSwiftNetworkingAlamofire

class Session: NSObject, Codable {
    @objc dynamic var uid: String?
    @objc dynamic var client: String?
    @objc dynamic var accessToken: String?
    @objc dynamic var expiry: Date?
    
    private enum CodingKeys: String, CodingKey {
        case uid
        case client
        case accessToken = "access-token"
        case expiry
    }
    
    var isValid: Bool {
        guard
            let uid = uid,
            let token = accessToken,
            let client = client
        else {
            return false
        }
        
        return !uid.isEmpty && !token.isEmpty && !client.isEmpty
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
    
    init?(headers: [AnyHashable: Any]) {
        guard var stringHeaders = headers as? [String: String] else {
            return nil
        }
        
        stringHeaders.lowercaseKeys()
        
        if let expiryString = stringHeaders[HTTPHeader.expiry.rawValue],
           let expiryNumber = Double(expiryString) {
            expiry = Date(timeIntervalSince1970: expiryNumber)
        }
        uid = stringHeaders[HTTPHeader.uid.rawValue]
        client = stringHeaders[HTTPHeader.client.rawValue]
        accessToken = stringHeaders[HTTPHeader.token.rawValue]
    }
}
