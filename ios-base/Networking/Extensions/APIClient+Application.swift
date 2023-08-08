import RSSwiftNetworking
import RSSwiftNetworkingAlamofire

/// Provides an easy-access APIClient implementation to use across the application
/// You can define and configure as many APIClients as needed
internal class Client {
  
  static let shared = Client()
  private let apiClient: APIClient
  
  init(apiClient: APIClient = BaseAPIClient(
    networkProvider: AlamofireNetworkProvider(),
    headersProvider: RailsAPIHeadersProvider(
      sessionProvider: SessionHeadersProvider()
    )
  )) {
    self.apiClient = apiClient
  }
}
