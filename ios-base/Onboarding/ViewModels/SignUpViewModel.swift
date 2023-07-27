//
//  SignUpViewModel.swift
//  ios-base
//
//  Created by German on 8/21/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpViewModelDelegate: AuthViewModelStateDelegate {
  func formDidChange()
}

enum AuthViewModelState {
  case loggedIn
  case network(state: NetworkState)
}

class SignUpViewModelWithEmail {
  
  private let analyticsManager: AnalyticsManager
  private let authServices: AuthenticationServices
  
  init(
    authServices: AuthenticationServices = AuthenticationServices(),
    analyticsManager: AnalyticsManager = .shared
  ) {
    self.authServices = authServices
    self.analyticsManager = analyticsManager
  }

  private var state: AuthViewModelState = .network(state: .idle) {
    didSet {
      delegate?.didUpdateState(to: state)
    }
  }
  
  weak var delegate: SignUpViewModelDelegate?
  
  var email = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var password = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var passwordConfirmation = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var hasValidData: Bool {
    email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation
  }
  
  @MainActor func signup() async {
    state = .network(state: .loading)
    let result = await authServices.signup(
      email: email,
      password: password,
      avatar64: UIImage.random()
    )
    
    switch result {
    case .success:
      self.state = .loggedIn
      AnalyticsManager.shared.identifyUser(with: self.email)
      AnalyticsManager.shared.log(event: Event.registerSuccess(email: self.email))
      AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
    case .failure(let error):
      self.state = .network(state: .error(error.localizedDescription))
    }
  }
}
