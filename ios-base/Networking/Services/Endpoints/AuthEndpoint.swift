import Foundation
import RSSwiftNetworking

internal enum AuthEndpoint: RailsAPIEndpoint {

  case signIn(email: String, password: String)
  case signUp(
    email: String,
    password: String,
    passwordConfirmation: String,
    picture: Data?
  )
  case logout
  case deleteAccount

  private static let usersURL = "/users/"
  private static let currentUserURL = "/user/"

  var path: String {
    switch self {
    case .signIn:
      return AuthEndpoint.usersURL + "sign_in"
    case .signUp:
      return AuthEndpoint.usersURL
    case .logout:
      return AuthEndpoint.usersURL + "sign_out"
    case .deleteAccount:
      return AuthEndpoint.currentUserURL + "delete_account"
    }
  }

  var method: Network.HTTPMethod {
    switch self {
    case .signIn, .signUp:
      return .post
    case .logout, .deleteAccount:
      return .delete
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .signIn(let email, let password):
      return [
        "user": [
          "email": email,
          "password": password
        ]
      ]
    case .signUp(let email, let password, let passwordConfirmation, let picture):
      var parameters = [
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      ]
      if let pictureData = picture {
        parameters["image"] = pictureData.asBase64Param()
      }
      return ["user": parameters]
    default:
      return [:]
    }
  }

}
