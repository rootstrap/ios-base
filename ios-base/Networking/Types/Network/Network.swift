import Foundation

internal enum Network {

  enum HTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
  }

  enum StatusCode {
    static let unauthorized = 401
  }

  internal struct Response {
      let statusCode: Int
      let data: Data?
      let headers: [String: String]
  }

  enum ProviderError: Error {
    case noResponse
  }

}
