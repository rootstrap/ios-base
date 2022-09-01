import Foundation

internal class SessionHeadersProvider: HeadersProvider {

  var requestHeaders: [String: String] {
    if let session = SessionManager.currentSession {
      return [
        HTTPHeader.uid.rawValue: session.uid ?? "",
        HTTPHeader.client.rawValue: session.client ?? "",
        HTTPHeader.token.rawValue: session.accessToken ?? ""
      ]
    }

    return [:]
  }
}
