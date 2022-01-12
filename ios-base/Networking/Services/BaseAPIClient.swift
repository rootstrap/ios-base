import Foundation

/// Concrete implementation of API Client.
internal final class BaseAPIClient: APIClient {

  // MARK: - Properties

  private let emptyDataStatusCodes: Set<Int> = [204, 205]

  private(set) var encodingConfiguration: EncodingConfiguration = .default

  private(set) var decodingConfiguration: DecodingConfiguration = .default

  private(set) var headersProvider: HeadersProvider = RailsAPIHeadersProvider(
    sessionHeadersProvider: SessionHeadersProvider()
  )

  private let networkProvider: NetworkProvider

  required init(networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }

  convenience init(
    networkProvider: NetworkProvider,
    headersProvider: HeadersProvider,
    encodingConfiguration: EncodingConfiguration = .default,
    decodingConfiguration: DecodingConfiguration = .default
  ) {
    self.init(networkProvider: networkProvider)
    self.encodingConfiguration = encodingConfiguration
    self.decodingConfiguration = decodingConfiguration
    self.headersProvider = headersProvider
  }

  @discardableResult
  func request<T: Decodable>(
    endpoint: Endpoint,
    completion: @escaping CompletionCallback<T>
  ) -> Cancellable {
    let apiEndpoint = APIEndpoint(endpoint: endpoint, headersProvider: headersProvider)

    return networkProvider.request(endpoint: apiEndpoint) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case.success(let response):
        self.validateResult(response: response, completion: completion)
      case .failure(let error):
        completion(.failure(error), [:])
      }
    }
  }

  @discardableResult
  func multipartRequest<T: Decodable>(
    endpoint: Endpoint,
    paramsRootKey: String,
    media: [MultipartMedia],
    completion: @escaping CompletionCallback<T>
  ) -> Cancellable {
    let apiEndpoint = APIEndpoint(endpoint: endpoint, headersProvider: headersProvider)

    return networkProvider.multipartRequest(
      endpoint: apiEndpoint,
      multipartFormKey: paramsRootKey,
      media: media
    ) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case.success(let response):
        self.validateResult(response: response, completion: completion)
      case .failure(let error):
        completion(.failure(error), [:])
      }
    }
  }

  private func handleCustomAPIError(from response: Network.Response) -> APIError? {
    if response.statusCode == Network.StatusCode.unauthorized {
      AppDelegate.shared.unexpectedLogout()
    }

    return APIError(response: response, decodingConfiguration: decodingConfiguration)
  }
  
  private func validateResult<T: Decodable>(
    response: Network.Response,
    completion: CompletionCallback<T>
  ) {
    let responseData = response.data

    guard let data = responseData, !data.isEmpty else {
      if emptyDataStatusCodes.contains(response.statusCode) {
        completion(.success(.none), response.headers)
      } else {
        let emptyResponseInvalidError = App.error(
          domain: .network,
          localizedDescription: "Unexpected empty response".localized
        )
        completion(.failure(emptyResponseInvalidError), response.headers)
      }

      return
    }

    let decoder = JSONDecoder(decodingConfig: self.decodingConfiguration)
    do {
      let decodedObject = try decoder.decode(T.self, from: data)

      completion(.success(decodedObject), response.headers)
    } catch let error {
      completion(
        .failure(handleCustomAPIError(from: response) ?? error),
        response.headers
      )
    }
  }
}
