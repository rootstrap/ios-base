//
//  APIError.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import Moya

struct APIError: Error {
  let statusCode: Int
  let error: RailsError

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
}
