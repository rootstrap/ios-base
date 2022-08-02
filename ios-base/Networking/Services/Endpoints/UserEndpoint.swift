import Foundation
import RSSwiftNetworking

internal enum UserEndpoint: RailsAPIEndpoint {

  case profile

  var path: String {
    "/user/profile"
  }

  var method: Network.HTTPMethod {
    .get
  }

}
