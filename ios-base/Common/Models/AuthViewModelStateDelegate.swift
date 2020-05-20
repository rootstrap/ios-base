//
//  AuthViewModelStateDelegate.swift
//  ios-base
//
//  Created by German on 5/20/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkStatusDelegate: class {
  func networkStatusChanged(to networkStatus: NetworkState)
}

protocol AuthViewModelStateDelegate: NetworkStatusDelegate {
  func didUpdateState(to state: AuthViewModelState)
}

extension AuthViewModelStateDelegate where Self: UIViewController {
  func didUpdateState(to state: AuthViewModelState) {
    switch state {
    case .network(let networkStatus):
      networkStatusChanged(to: networkStatus)
    case .loggedIn:
      UIApplication.hideNetworkActivity()
      AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
    }
  }
}

extension NetworkStatusDelegate where Self: UIViewController {
  func networkStatusChanged(to networkStatus: NetworkState) {
    switch networkStatus {
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      showMessage(title: "Error", message: errorDescription)
      fallthrough
    default:
      UIApplication.hideNetworkActivity()
    }
  }
}
