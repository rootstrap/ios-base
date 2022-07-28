//
//  LoginViewModel.swift
//  ios-base
//
//  Created by Lucas Miotti on 12/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

class LoginViewModel {
  
  var delegate: LoginDelegate?
  
  var email: String = ""
  var password: String = ""
  
  private var isEmailValid: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
  private var isPasswordValid: Bool {
    !password.isEmpty
  }
  
  func signIn() {
    if (isEmailValid && isPasswordValid) {
      authenticate()
      return
    }
    if !isEmailValid {
      delegate?.showEmailError()
    }
    if !isPasswordValid {
      delegate?.showPasswordError()
    }
  }
  
  private func authenticate() {
    TargetAuthServices.signIn(
      email: self.email,
      password: self.password
    ) { [weak self] result in
      switch result {
      case .success:
        self?.delegate?.onAuthSuccess()
      case .failure:
        self?.delegate?.onAuthError(errorCode: "")
      }
    }
  }
}
