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
    return
      email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation
  }
  
  func signup() {
    state = .network(state: .loading)
    AuthenticationServices.signup(
      email: email, password: password, avatar64: UIImage.random(),
      success: { [weak self] _ in
        guard let self = self else { return }
        self.state = .loggedIn
        AnalyticsManager.shared.identifyUser(with: self.email)
        AnalyticsManager.shared.log(event: Event.registerSuccess(email: self.email))
        AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
      },
      failure: { [weak self] error in
        self?.state = .network(state: .error(error.localizedDescription))
    })
  }
}
