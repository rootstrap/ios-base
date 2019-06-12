//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

enum SignInViewModelState: Equatable {
  case loading
  case idle
  case error(String)
  case loggedIn
}

protocol SignInViewModelDelegate: class {
  func didUpdateCredentials()
  func didUpdateState()
}

class SignInViewModelWithCredentials {
  
  var state: SignInViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: SignInViewModelDelegate?
  
  var email = "" {
    didSet {
      delegate?.didUpdateCredentials()
    }
  }
  
  var password = "" {
    didSet {
      delegate?.didUpdateCredentials()
    }
  }
  
  var hasValidCredentials: Bool {
    return email.isEmailFormatted() && !password.isEmpty
  }
  
  func login() {
    state = .loading
    UserService.sharedInstance
      .login(email,
             password: password,
             success: { [weak self] in
              guard let self = self else { return }
              self.state = .loggedIn
              AnalyticsManager.shared.identifyUser(with: self.email)
              AnalyticsManager.shared.log(event: Event.login)
             },
             failure: { [weak self] error in
               self?.state = .error(error.localizedDescription)
             })
  }
}
