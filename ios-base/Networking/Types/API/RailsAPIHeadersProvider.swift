import Foundation

internal final class RailsAPIHeadersProvider: HeadersProvider {

  private let sessionHeadersProvider: SessionHeadersProvider

  private let contentTypeJSON = "application/json"

  var requestHeaders: [String: String] {
    sessionHeadersProvider.requestHeaders + [
      HTTPHeader.accept.rawValue: contentTypeJSON,
      HTTPHeader.contentType.rawValue: contentTypeJSON
    ]
  }

  init(sessionHeadersProvider: SessionHeadersProvider) {
    self.sessionHeadersProvider = sessionHeadersProvider
  }

}
