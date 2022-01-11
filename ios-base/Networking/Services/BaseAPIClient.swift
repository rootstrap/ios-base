//
//  APIClient.swift
//  ios-base
//
//  Created by Germán Stábile on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

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

  // Recursively build multipart params to send along with media in upload requests.
  // If params includes the desired root key,
  // call this method with an empty String for rootKey param.
  //  class func multipartFormData(
  //    _ multipartForm: MultipartFormData,
  //    params: Any,
  //    rootKey: String
  //  ) {
  //    switch params.self {
  //    case let array as [Any]:
  //      for val in array {
  //        let forwardRootKey = rootKey.isEmpty ? "array[]" : rootKey + "[]"
  //        multipartFormData(multipartForm, params: val, rootKey: forwardRootKey)
  //      }
  //    case let dict as [String: Any]:
  //      for (key, value) in dict {
  //        let forwardRootKey = rootKey.isEmpty ? key : rootKey + "[\(key)]"
  //        multipartFormData(multipartForm, params: value, rootKey: forwardRootKey)
  //      }
  //    default:
  //      if let uploadData = "\(params)".data(
  //        using: String.Encoding.utf8,
  //        allowLossyConversion: false
  //      ) {
  //        let forwardRootKey = rootKey.isEmpty ?
  //          "\(type(of: params))".lowercased() : rootKey
  //        multipartForm.append(uploadData, withName: forwardRootKey)
  //      }
  //    }
  //  }
  
  // Multipart-form base request. Used to upload media along with desired params.
  // Note: Multipart request does not support Content-Type = application/json.
  // If your API requires this header
  // do not use this method or change backend to skip this validation.
  //  class func multipartRequest(
  //    method: HTTPMethod = .post,
  //    url: String,
  //    headers: [String: String] = BaseAPIClient.getHeaders(),
  //    params: [String: Any]?,
  //    paramsRootKey: String,
  //    media: [MultipartMedia],
  //    success: @escaping SuccessCallback,
  //    failure: @escaping FailureCallback
  //  ) {
  //
  //    let requestConvertible = BaseURLRequestConvertible(
  //      path: url,
  //      method: method,
  //      headers: headers
  //    )
  //
  //    AF.upload(
  //      multipartFormData: { (multipartForm) -> Void in
  //        if let parameters = params {
  //          multipartFormData(multipartForm, params: parameters, rootKey: paramsRootKey)
  //        }
  //        for elem in media {
  //          elem.embed(inForm: multipartForm)
  //        }
  //      },
  //      with: requestConvertible
  //    )
  //    .responseJSON(completionHandler: { result in
  //      validateResult(result: result, success: success, failure: failure)
  //    })
  //  }

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
