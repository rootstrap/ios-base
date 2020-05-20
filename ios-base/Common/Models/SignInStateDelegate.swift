//
//  SignInStateDelegate.swift
//  ios-base
//
//  Created by German on 5/20/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SignInStateDelegate: class {
  func didUpdateState(to state: SignInViewModelState)
}

extension SignInStateDelegate where Self: UIViewController {
  func didUpdateState(to state: SignInViewModelState) {
    switch state {
    case .network(let networkStatus):
      switch networkStatus {
      case .loading:
        UIApplication.showNetworkActivity()
      case .error(let errorDescription):
        showMessage(title: "Error", message: errorDescription)
        fallthrough
      default:
        UIApplication.hideNetworkActivity()
      }
    case .loggedIn:
      UIApplication.hideNetworkActivity()
      AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
    }
  }
}
