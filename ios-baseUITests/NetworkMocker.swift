//
//  NetworkMocker.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 6/30/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation
import Swifter
import XCTest

enum HTTPMethod {
  case POST
  case GET
  case PUT
  case DELETE
}

internal class NetworkMocker {
  
  private(set) lazy var server = HttpServer()
  
  func setUp() throws {
    try server.start()
  }
  
  func tearDown() {
    server.stop()
  }
  
  public func stub(
    url: String,
    responseFilename: String,
    method: HTTPMethod = .GET,
    customHeaders: [String: String]? = nil
  ) {
    let testBundle = Bundle(for: type(of: self))
    let filePath = testBundle.path(forResource: responseFilename, ofType: "json") ?? ""
    let fileURL = URL(fileURLWithPath: filePath)

    do {
      let data = try Data(contentsOf: fileURL, options: .uncached)
      let jsonObject = try data.jsonObject()

      let response: ((HttpRequest) -> HttpResponse) = { _ in
        if let customHeaders = customHeaders {
          return HttpResponse.raw(200, "OK", customHeaders) { bodyWriter in
            try bodyWriter.write(data)
          }
        }
        guard let jsonObject = jsonObject else {
          XCTFail("A valid JSON couldn't be parsed")
          return .badRequest(.none)
        }
        return HttpResponse.ok(.json(jsonObject))
      }
      
      switch method {
      case .GET: server.GET[url] = response
      case .POST: server.POST[url] = response
      case .DELETE: server.DELETE[url] = response
      case .PUT: server.PUT[url] = response
      }
    } catch let error {
      XCTFail("Failed to serialize JSON. Error \(error)")
    }
  }
}

internal extension Data {
  func jsonObject(
    options: JSONSerialization.ReadingOptions = .mutableContainers
  ) throws -> Any? {
    try JSONSerialization.jsonObject(with: self, options: options)
  }
}
