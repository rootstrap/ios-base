import Foundation
import Alamofire

/// This should be the only place where the `Alamofire` dependency is imported
internal final class AlamofireNetworkProvider: NetworkProvider {

  func request(
    endpoint: Endpoint,
    completion: @escaping (Result<Network.Response, Error>) -> Void
  ) -> Cancellable {
    let headers = HTTPHeaders(endpoint.headers)

    return AF.request(
      endpoint.requestURL,
      method: endpoint.method.alamofireMethod,
      parameters: endpoint.parameters,
      headers: headers
    )
    .validate()
    .response { afResponse in
      switch afResponse.result {
      case.success:
        guard let response = afResponse.response else {
          completion(.failure(Network.ProviderError.noResponse))
          return
        }

        completion(.success(Network.Response(
          statusCode: response.statusCode,
          data: afResponse.data,
          headers: response.headers.dictionary
        )))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

}

extension Network.HTTPMethod {
  var alamofireMethod: Alamofire.HTTPMethod {
    switch self {
    case .get:
      return .get
    case .post:
      return .post
    case .put:
      return .put
    case .delete:
      return .delete
    case .patch:
      return .patch
    }
  }
}

extension DataRequest: Cancellable {}
