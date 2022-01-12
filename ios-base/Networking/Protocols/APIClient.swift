import Foundation

internal struct EmptyResponse: Decodable {}

internal typealias CompletionCallback<T: Decodable> = (
  _ result: Result<T?, Error>,
  _ responseHeaders: [String: String]
) -> Void

/// Defines the requirement for an API Client object
internal protocol APIClient {

  /// Returns the base encoding configration for all requests parameters.
  /// Will be overriden by the `Endpoint` encoding configuration, if any.
  var encodingConfiguration: EncodingConfiguration { get }

  /// Returns the base decoding configration for all request reponses.
  /// Will be overriden by the `Endpoint` decoding configuration, if any.
  var decodingConfiguration: DecodingConfiguration { get }

  /// Initializes an instance of the `APIClient` conformant object.
  /// Any API Client concrete instance should be injected with the network provider.
  init(networkProvider: NetworkProvider)

  /// Performs the request by using the provided `NetworkProvider`.
  /// - Returns: A `Cancellable` request.
  func request<T: Decodable>(
    endpoint: Endpoint,
    completion: @escaping CompletionCallback<T>
  ) -> Cancellable

  /// Performs a multipart request to upload one or many `MultipartMedia` objects.
  /// The endpoint parameters will be encoded in the multipart form.
  /// Note: Multipart requests do not support `Content-Type = application/json` headers.
  /// If your API requires this header user base64 uploads instead.
  func multipartRequest<T: Decodable>(
    endpoint: Endpoint,
    paramsRootKey: String,
    media: [MultipartMedia],
    completion: @escaping CompletionCallback<T>
  ) -> Cancellable
}
