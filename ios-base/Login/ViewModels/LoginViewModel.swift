//
//  LoginViewModel.swift
//  ios-base
//
//  Created by Lucas Miotti on 12/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import FBSDKLoginKit

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
      case .success(let user):
        UserDataManager.currentUser = user
        self?.delegate?.onAuthSuccess()
      case .failure:
        self?.delegate?.onAuthError(errorCode: "")
      }
    }
  }
  
  func facebookSignIn() {
    guard let viewController = delegate as? UIViewController else { return }
    let fbLoginManager = LoginManager()
    // Logs out before login, in case user changes facebook accounts
    fbLoginManager.logIn(
      permissions: ["email"],
      from: viewController,
      handler: handleFacebookResponse
    )
  }
  
  private func handleFacebookResponse(result: LoginManagerLoginResult?, error: Error?) {
    guard let result = result, error == nil else {
      self.delegate?.onAuthError(errorCode: error?.localizedDescription ?? "")
      return
    }
    if result.isCancelled {
      self.delegate?.onAuthError(errorCode: "User cancelled")
    } else if !result.grantedPermissions.contains("email") {
      self.delegate?.onAuthError(
        errorCode: "It seems that you haven't allowed Facebook to provide your email address."
      )
    } else {
      signInWithFacebook(accessToken: result.token?.tokenString ?? "")
    }
  }
  
  private func signInWithFacebook(accessToken: String) {
    TargetAuthServices.authWithFacebook(
      accessToken: accessToken
    ) { [weak self] result in
        switch result {
        case .success(let user):
          UserDataManager.currentUser = user
          self?.delegate?.onAuthSuccess()
        case .failure:
          self?.delegate?.onAuthError(errorCode: "")
        }
    }
  }
}
