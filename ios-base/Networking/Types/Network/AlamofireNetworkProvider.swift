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
    .response { [weak self] afResponse in
      switch afResponse.result {
      case.success:
        self?.handleAlamofireResponse(afResponse, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func multipartRequest(
    endpoint: Endpoint,
    multipartFormKey: String,
    media: [MultipartMedia],
    completion: @escaping (Result<Network.Response, Error>) -> Void
  ) -> Cancellable {
    AF.upload(
      multipartFormData: { [weak self] multipartForm in
        self?.encodeParameters(
          endpoint.parameters,
          intoMultipartFormData: multipartForm,
          rootKey: multipartFormKey
        )
        for elem in media {
          elem.embed(inForm: multipartForm)
        }
      },
      to: endpoint.requestURL,
      method: endpoint.method.alamofireMethod,
      headers: HTTPHeaders(endpoint.headers)
    )
    .validate()
    .response { [weak self] afResponse in
      switch afResponse.result {
      case.success:
        self?.handleAlamofireResponse(afResponse, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func handleAlamofireResponse(
    _ afResponse: AFDataResponse<Data?>,
    completion: @escaping (Result<Network.Response, Error>) -> Void
  ) {
    guard let response = afResponse.response else {
      completion(.failure(Network.ProviderError.noResponse))
      return
    }

    completion(.success(Network.Response(
      statusCode: response.statusCode,
      data: afResponse.data,
      headers: response.headers.dictionary
    )))
  }

  /// Recursively builds the parameters into  the multipart form
  /// to send along with media in upload requests.
  /// - Parameters:
  ///   - multipartForm: The mutable form data to append the parameters
  ///   - parameters: The input parementers to encode into the multipart form.
  ///   - rootKey: The root key for the encoded parameters or an empty string.
  ///     If `parameters` is a dictionary that already includes the desired root key
  ///     you can omit the.
  private func encodeParameters(
    _ parameters: Any,
    intoMultipartFormData multipartForm: MultipartFormData,
    rootKey: String = ""
  ) {
    switch parameters.self {
    case let array as [Any]:
      for value in array {
        encodeParameters(
          value,
          intoMultipartFormData: multipartForm,
          rootKey: rootKey.isEmpty ? "array[]" : rootKey + "[]"
        )
      }
    case let dict as [String: Any]:
      for (key, value) in dict {
        encodeParameters(
          value,
          intoMultipartFormData: multipartForm,
          rootKey: rootKey.isEmpty ? key : rootKey + "[\(key)]"
        )
      }
    default:
      if let uploadData = "\(parameters)".data(
        using: String.Encoding.utf8,
        allowLossyConversion: false
      ) {
        let forwardRootKey = rootKey.isEmpty
          ? "\(type(of: parameters))".lowercased()
          : rootKey

        multipartForm.append(uploadData, withName: forwardRootKey)
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

fileprivate extension MultipartMedia {
  func embed(inForm multipart: MultipartFormData) {
    multipart.append(data, withName: key, fileName: toFile, mimeType: type.rawValue)
  }
}
