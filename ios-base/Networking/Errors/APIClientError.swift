import Foundation

internal enum APIClientError: Error {
    case invalidEmptyResponse
    case statusCodeInvalid
    
    var domain: ErrorDomain {
        .network
    }

    var code: Int {
        switch self {
        case .invalidEmptyResponse:
            return 1
        case .statusCodeInvalid:
            return 2
        }
    }

}
