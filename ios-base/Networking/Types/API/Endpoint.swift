import Foundation

internal enum EndpointError: Error {
  case invalidURL
}

/// Base requirements for any network request endpoint.
internal protocol Endpoint {

  var requestURL: URL { get }
  var method: Network.HTTPMethod { get }

  var headers: [String: String] { get }
  var parameters: [String: Any] { get }
  var decodingConfiguration: DecodingConfiguration? { get }

}

extension Endpoint {

  // MARK: - Defaults

  var decodingConfiguration: DecodingConfiguration? {
    nil
  }

  var parameters: [String: Any] {
    [:]
  }

  var headers: [String: String] {
    [:]
  }

}
