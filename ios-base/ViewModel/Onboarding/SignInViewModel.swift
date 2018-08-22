//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

class SignInViewModelWithCredentials {
  
  var email = "" {
    didSet {
      onCredentialsChange?()
    }
  }
  var password = "" {
    didSet {
      onCredentialsChange?()
    }
  }
  var onCredentialsChange: (() -> Void)?
  
  var hasValidCredentials: Bool {
    return email.isEmailFormatted() && !password.isEmpty
  }
  
  func login(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
    UserAPI.login(email, password: password, success: success, failure: { error in
      failure(error.localizedDescription)
    })
  }
}
