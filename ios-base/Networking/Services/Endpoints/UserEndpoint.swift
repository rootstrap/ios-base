import Foundation

internal enum UserEndpoint: RailsAPIEndpoint {
  var parameters: Any
  

  case profile

  var path: String {
    "/user/profile"
  }

  var method: Network.HTTPMethod {
    .get
  }

}
