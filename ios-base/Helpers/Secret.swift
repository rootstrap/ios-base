import Foundation

/// Enclosing type to handle secret values configuration and fetching.
enum Secret {

  // All keys for secrets used within the app.
  enum Key: String {
    case facebookKey = "FacebookKey"
  }

  enum Error: Swift.Error {
    case missingKey, invalidValue
  }

  /// Fetches the secret value, if any, for the given key.
  /// - Parameters:
  ///   - key: The `Secret.Key` object to search the value for.
  /// - Returns: The value if found. An expception is thrown otherwise.
  static func value<T>(
    for key: Secret.Key
  ) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
      throw Error.missingKey
    }

    switch object {
    case let value as T:
      return value
    case let string as String:
      guard let value = T(string) else { fallthrough }
      return value
    default:
      throw Error.invalidValue
    }
  }
}
