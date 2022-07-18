//
//  OnboardingRoutes.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

enum OnboardingRoutes: Route {
  case firstScreen
  case signIn
  case signUp
  case login

  var screen: UIViewController {
    switch self {
    case .firstScreen:
      return buildFirstViewController()
    case .signIn:
      return buildSignInViewController()
    case .signUp:
      return buildSignUpViewController()
    case .login:
      return buildLogInViewController()
    }
  }

  private func buildSignInViewController() -> UIViewController {
    let signIn = SignInViewController(viewModel: SignInViewModelWithCredentials())
    return signIn
  }

  private func buildSignUpViewController() -> UIViewController {
    let signUp = SignUpViewController(viewModel: SignUpViewModelWithEmail())
    return signUp
  }

  private func buildFirstViewController() -> UIViewController {
    let firstViewController = FirstViewController(viewModel: FirstViewModel())
    return firstViewController
  }
  
  private func buildLogInViewController() -> UIViewController {
    /*
    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
    return vc
     */
    
    let loginViewController = LoginViewController(viewModel: LoginViewModel())
    return loginViewController
  }
}
