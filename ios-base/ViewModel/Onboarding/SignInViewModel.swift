//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate: class {
  func didUpdateCredentials()
  func didUpdateState()
}

class SignInViewModelWithCredentials {
  
  var state: ViewModelState = .idle {
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
              self.state = .idle
              AnalyticsManager.shared.identifyUser(with: self.email)
              AnalyticsManager.shared.log(event: Event.login)
              AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
             },
             failure: { [weak self] error in
               self?.state = .error(error.localizedDescription)
             })
  }
}
