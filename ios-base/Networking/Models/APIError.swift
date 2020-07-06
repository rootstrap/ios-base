//
//  APIError.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import Moya

struct APIError: Error {
  let statusCode: Int
  let error: RailsError

  /// Returns the first error returned by the API
  var firstError: String? {
    if let errors = error.errors, let firstMessage = errors.first {
        return "\(firstMessage.key) \(firstMessage.value.first ?? "")"
    } else if let errorString = error.error {
      return errorString
    }

    return nil
  }

  /// Returns an array containing all error values returned from the API
  var errors: [String] {
    var flattenedErrors = error.errors?
      .compactMap { $0.value }
      .flatMap { $0 }

    if let errorString = error.error {
      flattenedErrors?.append(errorString)
    }

    return flattenedErrors ?? []
  }

  static func from(response: Response) -> APIError? {
    guard let decodedError = try? response.map(RailsError.self) else {
      return nil
    }
    return APIError(statusCode: response.statusCode, error: decodedError)
  }
}

struct RailsError: Decodable {
  let errors: [String: [String]]?
  let error: String?

  enum CodingKeys: String, CodingKey {
    case errors
    case error
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if let errors = try? values.decode([String: [String]].self, forKey: .errors) {
      self.errors = errors
      self.error = nil
    } else if let error = try? values.decode(String.self, forKey: .errors) {
      self.error = error
      self.errors = nil
    } else {
      error = try? values.decode(String.self, forKey: .error)
      errors = nil
    }
  }
}
