//
//  NetworkMocker.swift
//  ios-baseUITests
//
//  Created by Germán Stábile on 6/30/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation
import Swifter

enum HTTPMethod {
  case POST
  case GET
  case PUT
  case DELETE
}

class NetworkMocker {
  
  var server = HttpServer()
  
  func setUp() {
    try! server.start()
  }
  
  func tearDown() {
    server.stop()
  }
  
  public func setupStub(
    url: String,
    responseFilename: String,
    method: HTTPMethod = .GET
  ) {
    let testBundle = Bundle(for: type(of: self))
    let filePath = testBundle.path(forResource: responseFilename, ofType: "json") ?? ""
    let fileUrl = URL(fileURLWithPath: filePath)
    guard let data = try? Data(contentsOf: fileUrl, options: .uncached) else {
      fatalError("Could not parse mocked data")
    }
    let json = dataToJSON(data: data)
    
    let response: ((HttpRequest) -> HttpResponse) = { _ in
      HttpResponse.ok(.json(json as AnyObject))
    }
    
    switch method {
    case .GET: server.GET[url] = response
    case .POST: server.POST[url] = response
    case .DELETE: server.DELETE[url] = response
    case .PUT: server.PUT[url] = response
    }
  }
  
  func dataToJSON(data: Data) -> Any? {
    do {
      return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch let error {
      print(error)
    }
    return nil
  }
}
