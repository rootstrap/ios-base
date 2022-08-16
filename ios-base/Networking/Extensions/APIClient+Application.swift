import RSSwiftNetworking

/// Provides an easy-access APIClient implementation to use across the application
/// You can define and configure as many APIClients as needed
internal enum iOSBaseAPIClient {
  static let shared = BaseAPIClient(
    networkProvider: AlamofireNetworkProvider(),
    headersProvider: RailsAPIHeadersProvider(sessionProvider: SessionHeadersProvider())
  )
}
