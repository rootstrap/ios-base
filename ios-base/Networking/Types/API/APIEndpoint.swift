import Foundation

internal struct APIEndpoint: Endpoint {

  private let headersProvider: HeadersProvider
  private let endpoint: Endpoint

  init(endpoint: Endpoint, headersProvider: HeadersProvider) {
    self.endpoint = endpoint
    self.headersProvider = headersProvider
  }

  var requestURL: URL {
    endpoint.requestURL
  }

  var method: Network.HTTPMethod {
    endpoint.method
  }

  var headers: [String: String] {
    endpoint.headers + headersProvider.requestHeaders
  }

  var parameters: [String: Any] {
    endpoint.parameters
  }

  var decodingConfiguration: DecodingConfiguration? {
    endpoint.decodingConfiguration
  }

}
