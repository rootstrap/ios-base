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
  
  private let analyticsManager: AnalyticsManager

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
  
  init(
    authServices: AuthenticationServices = AuthenticationServices(),
    analyticsManager: AnalyticsManager = .shared
  ) {
    self.authServices = authServices
    self.analyticsManager = analyticsManager
  }
  
  @MainActor func login() async {
    state = .network(state: .loading)
    let result = await authServices.login(
      email: email,
      password: password
    )
    switch result {
    case .success:
      self.state = .loggedIn
      analyticsManager.identifyUser(with: self.email)
      analyticsManager.log(event: Event.login)
    case .failure(let error):
      self.state = .network(state: .error(error.localizedDescription))
    }
  }
}
