import Foundation

internal enum HTTPHeader: String {
  case uid
  case client
  case expiry
  case token = "access-token"
  case accept = "Accept"
  case contentType = "Content-Type"
}
