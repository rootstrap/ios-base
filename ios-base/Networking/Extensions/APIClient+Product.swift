/// Definition for API clients used in the application.
/// i.e. `OtherAPIClient(networkProvider: URLSessionNetworkProvider())`
///
extension BaseAPIClient {
  static let `default` = BaseAPIClient(
    networkProvider: AlamofireNetworkProvider(),
    headersProvider: RailsAPIHeadersProvider(
      sessionHeadersProvider: SessionHeadersProvider()
    )
  )
}
