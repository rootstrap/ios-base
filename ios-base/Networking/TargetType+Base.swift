//
//  TargetType+Base.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import Moya

// MARK: TargetType base configuration
extension TargetType {

  var baseURL: URL {
    let baseUrlString = Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String ?? ""
    return URL(string: baseUrlString)!
  }

  var headers: [String: String]? {
    return getHeaders()
  }

  var sampleData: Data { return Data() }

}

// MARK: TargetType helpers
extension TargetType {

  static private var baseHeaders: [String: String] {
    return [
      HTTPHeader.accept.rawValue: "application/json",
      HTTPHeader.contentType.rawValue: "application/json"
    ]
  }

  public func getHeaders() -> [String: String]? {
    if let session = SessionManager.currentSession {
      return Self.baseHeaders + [
        HTTPHeader.uid.rawValue: session.uid ?? "",
        HTTPHeader.client.rawValue: session.client ?? "",
        HTTPHeader.token.rawValue: session.accessToken ?? ""
      ]
    }
    return Self.baseHeaders
  }

  public func requestParameters(parameters: [String: Any]) -> Task {
    return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
  }

  public func multipartData(from parameters: [String: Any]) -> [MultipartFormData] {
    return parameters.map { (key: String, value: Any) -> MultipartFormData? in
      let value = value
      let key = "user[\(key)]"
      if let value = value as? Data {
        return MultipartFormData(provider: .data(value), name: key)
      } else if let data = "\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false) {
        return MultipartFormData(provider: .data(data), name: key)
      }
      return nil
    }.compactMap { $0 }
  }

}
