//
//  UserService.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import Moya

class UserService: BaseApiService<UserResource> {
  static let sharedInstance = UserService()

  static func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    sharedInstance.request(for: .login(email, password), at: "user", onSuccess: { (result: User, response) -> Void in
      guard let headers = response.response?.allHeaderFields else {
        return
      }
      saveUserSession(user: result, headers: headers)
      success()
    })
  }

  static func saveUserSession(user: User, headers: [AnyHashable: Any]) {
    UserDataManager.currentUser = user
    if let headers = headers as? [String: Any] {
      SessionManager.currentSession = Session(headers: headers)
    }
  }

  static func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    sharedInstance.request(for: UserResource.logout, onSuccess: { _ in
      UserDataManager.deleteUser()
      SessionManager.deleteSession()
      success()
    }, onFailure: { error, _ in
      failure(error)
    })
  }
}
