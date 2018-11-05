//
//  SignUpViewModel.swift
//  ios-base
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

enum SignUpViewModelState {
  case loading
  case idle
  case error(String)
  case signedUp
}

protocol SignUpViewModelDelegate: class {
  func formDidChange()
  func didUpdateState()
}

class SignUpViewModelWithEmail {
  
  var state: SignUpViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
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
    return email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation
  }
  
  func signup() {
    state = .loading
    UserAPI.signup(email, password: password,
                   avatar64: UIImage.random(),
                   success: { [weak self] _ in
                    self?.state = .signedUp
                   },
                   failure: { [weak self] error in
                    self?.state = .error(error.localizedDescription)
                  })
  }
}
