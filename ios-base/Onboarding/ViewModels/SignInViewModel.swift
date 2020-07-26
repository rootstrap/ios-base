//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate: AuthViewModelStateDelegate {
  func didUpdateCredentials()
}

class SignInViewModelWithCredentials {
  
  private var state: AuthViewModelState = .network(state: .idle) {
    didSet {
      delegate?.didUpdateState(to: state)
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
    state = .network(state: .loading)
    AuthenticationServices.login(
      email: email,
      password: password,
      success: { [weak self] in
        guard let self = self else { return }
        self.state = .loggedIn
        AnalyticsManager.shared.identifyUser(with: self.email)
        AnalyticsManager.shared.log(event: Event.login)
      },
      failure: { [weak self] error in
        self?.state = .network(state: .error(error.localizedDescription))
    })
  }
}
