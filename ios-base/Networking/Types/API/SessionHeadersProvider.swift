import Foundation
import RSSwiftNetworking

internal protocol CurrentUserSessionProvider {
  var currentSession: Session? { get }
}

internal class SessionHeadersProvider: SessionProvider {

  // MARK: - Properties

  var uid: String? {
    session?.uid
  }

  var client: String? {
    session?.client
  }

  var accessToken: String? {
    session?.accessToken
  }

  private let currentSessionProvider: CurrentUserSessionProvider

  private var session: Session? {
    currentSessionProvider.currentSession
  }

  // MARK: -

  init(currentSessionProvider: CurrentUserSessionProvider = SessionManager.shared) {
    self.currentSessionProvider = currentSessionProvider
  }
}
