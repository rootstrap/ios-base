import Foundation

/// A structure that represents a custom error returned by the API
/// in the request response.
internal struct APIError: Error {
  let statusCode: Int
  let underlayingError: RailsError

  init?(
    response: Network.Response,
    decodingConfiguration: DecodingConfiguration
  ) {
    let decoder = JSONDecoder(decodingConfig: decodingConfiguration)
    guard
      let data = response.data,
      let decodedError = try? decoder.decode(RailsError.self, from: data)
    else {
      return nil
    }

    self.statusCode = response.statusCode
    self.underlayingError = decodedError
  }

  /// Returns the first error returned by the API
  var firstError: String? {
    if let errors = underlayingError.errors, let firstMessage = errors.first {
        return "\(firstMessage.key) \(firstMessage.value.first ?? "")"
    } else if let errorString = underlayingError.error {
      return errorString
    }

    return nil
  }

  /// Returns an array containing all error values returned from the API
  var errors: [String] {
    var flattenedErrors = underlayingError.errors?
      .compactMap { $0.value }
      .flatMap { $0 }

    if let errorString = underlayingError.error {
      flattenedErrors?.append(errorString)
    }

    return flattenedErrors ?? []
  }
}

/// A structure that represents a Ruby on Rails API error object
internal struct RailsError: Decodable {

  let errors: [String: [String]]?
  let error: String?

  enum CodingKeys: String, CodingKey {
    case errors
    case error
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if let errors = try? values.decode([String: [String]].self, forKey: .errors) {
      self.errors = errors
      self.error = nil
    } else if let error = try? values.decode(String.self, forKey: .errors) {
      self.error = error
      self.errors = nil
    } else {
      error = try? values.decode(String.self, forKey: .error)
      errors = nil
    }
  }
}
