//
//  Errors.swift
//  ios-base
//
//  Created by German on 5/20/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

/**
 App-specific error domains enumerated.
 Includes a default error code and a default a localized description.
 */
enum ErrorDomain {
  case generic
  case parsing(_: Localizable.Type)
  case networkRequest
  
  var name: String {
    switch self {
    case .parsing: return "PARSING_ERROR"
    case .networkRequest: return "NETWORK_FAILURE"
    default: return "GENERIC_ERROR"
    }
  }
  
  var defaultCode: ErrorCode {
    switch self {
    case .parsing: return .invalidData
    case .networkRequest: return .badNetworkRequest
    default: return .generic
    }
  }
  
  var localizedDescription: String {
    switch self {
    case .parsing(let objectClass):
      return String(format: name.localized, objectClass.localized)
    default: return name.localized
    }
  }
}

enum ErrorCode: Int {
  case generic = 18190
  case invalidData = 18191
  case badNetworkRequest = 400
}

protocol Localizable {
  static var localizeKey: String { get }
  static var localized: String { get }
}

extension Localizable {
  static var localizeKey: String {
    return String(describing: self)
  }
  
  static var localized: String { return localizeKey.localized }
}

extension App {
  /**
   Create app-specific errors with custom domains.
   Optionally accepts the error code and localized description.
   */
  static func error(domain: ErrorDomain = .generic,
                    code: Int? = nil,
                    localizedDescription: String = "") -> NSError {
    let description = localizedDescription.isEmpty ? domain.localizedDescription : localizedDescription
    return NSError(domain: App.domain + "." + domain.name,
                   code: code ?? domain.defaultCode.rawValue,
                   userInfo: [NSLocalizedDescriptionKey: description])
  }
}
