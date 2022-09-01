import Foundation

internal enum UserEndpoint: RailsAPIEndpoint {

  case profile

  var path: String {
    "/user/profile"
  }

  var method: Network.HTTPMethod {
    .get
  }

}
