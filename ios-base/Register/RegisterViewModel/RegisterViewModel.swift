//
//  RegisterViewModel.swift
//  ios-base
//
//  Created by Lucas Miotti on 19/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

class RegisterViewModel {
  
  var delegate: RegisterDelegate?
  private var networkState: NetworkState = NetworkState.idle
  
  var name = ""
  var email: String = ""
  var password: String = ""
  var confirmPassword: String = ""
  var gender: String = ""
  
  private var isNameValid: Bool {
    !name.isEmpty
  }
  
  private var isEmailValid: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
  
  private var isPasswordValid: Bool {
    password.count >= 6
  }
  
  private var arePasswordsEqual: Bool {
    password == confirmPassword && !password.isEmpty
  }
  private var isGenderValid: Bool {
    !gender.isEmpty
  }
  
  func signUp() {
    if isNameValid && isEmailValid && isPasswordValid && arePasswordsEqual {
      registerUser()
      return
    }
    
    if !isNameValid {
      delegate?.showNameError()
    }
    if !isEmailValid {
      delegate?.showEmailError()
    }
    if !isPasswordValid {
      delegate?.showPasswordError()
    }
    if !arePasswordsEqual {
      delegate?.showConfirmPasswordError()
    }
    if !isGenderValid {
      delegate?.showGenderError()
    }
  }
  
  private func registerUser() {
    TargetAuthServices.register(
      username: self.name,
      email: self.email,
      gender: self.gender,
      password: self.password,
      passwordConfirmation: self.confirmPassword
    ) { [weak self] result in
      self?.networkState = NetworkState.loading
      switch result {
      case .success:
        self?.networkState = NetworkState.idle
        self?.delegate?.onAuthSuccess()
      case .failure:
        self?.networkState = NetworkState.error("")
        self?.delegate?.onAuthError(errorCode: "")
      }
    }
  }
}
