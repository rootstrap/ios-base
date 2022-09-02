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
  
  var server = HttpServer()
  
  func setUp() throws {
    try server.start()
  }
  
  func tearDown() {
    server.stop()
  }
  
  public func stub(
    url: String,
    responseFilename: String,
    method: HTTPMethod = .GET
  ) {
    let testBundle = Bundle(for: type(of: self))
    let filePath = testBundle.path(forResource: responseFilename, ofType: "json") ?? ""
    let fileURL = URL(fileURLWithPath: filePath)

    do {
      let jsonObject = try Data(contentsOf: fileURL, options: .uncached).jsonObject()
      guard let jsonObject = jsonObject else {
        XCTFail("A valid JSON couldn't be parsed")
        return
      }

      let response: ((HttpRequest) -> HttpResponse) = { _ in
        HttpResponse.ok(.json(jsonObject))
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
