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

internal class SignInViewModelWithCredentials {

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
    email.isEmailFormatted() && !password.isEmpty
  }

  private let authServices: AuthenticationServices

  init(authServices: AuthenticationServices = AuthenticationServices()) {
    self.authServices = authServices
  }
  
  func login() {
    state = .network(state: .loading)
    authServices.login(
      email: email,
      password: password
    ) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success:
        self.state = .loggedIn
        AnalyticsManager.shared.identifyUser(with: self.email)
        AnalyticsManager.shared.log(event: Event.login)
      case .failure(let error):
        self.state = .network(state: .error(error.localizedDescription))
      }
    }
  }
}
