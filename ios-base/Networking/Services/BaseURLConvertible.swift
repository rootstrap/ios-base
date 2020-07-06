//
//  BaseURLConvertible.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import Alamofire

class BaseURLConvertible: URLConvertible {
  
  let path: String
  let baseUrl: String
  
  init(path: String, baseUrl: String = APIClient.getBaseUrl()) {
    self.path = path
    self.baseUrl = baseUrl
  }
  
  func asURL() throws -> URL {
    return URL(string: "\(baseUrl)\(path)")!
  }
}

class BaseURLRequestConvertible: URLRequestConvertible {
  let url: URLConvertible
  let method: HTTPMethod
  let headers: HTTPHeaders
  let params: [String: Any]?
  let encoding: ParameterEncoding?
  
  func asURLRequest() throws -> URLRequest {
    let request = try URLRequest(
      url: url,
      method: method,
      headers: headers
    )
    if let params = params, let encoding = encoding {
      return try encoding.encode(request, with: params)
    }
    
    return request
  }
  
  init(
    path: String,
    baseUrl: String = APIClient.getBaseUrl(),
    method: HTTPMethod,
    encoding: ParameterEncoding? = nil,
    params: [String: Any]? = nil,
    headers: [String: String] = [:]
  ) {
    url = BaseURLConvertible(path: path, baseUrl: baseUrl)
    self.method = method
    self.headers = HTTPHeaders(headers)
    self.params = params
    self.encoding = encoding
  }
}
