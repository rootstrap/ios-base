//
//  FirstViewModel.swift
//  ios-base
//
//  Created by German Stabile on 11/2/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import FBSDKLoginKit

protocol FirstViewModelDelegate: class {
  func didUpdateState()
}

class FirstViewModel {
  
  var state: ViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: FirstViewModelDelegate?
  
  func facebookLogin() {
    guard let viewController = delegate as? UIViewController else { return }
    let facebookKey = ConfigurationManager.getValue(for: "FacebookKey", on: "Info")
    assert(!(facebookKey?.isEmpty ?? false), "Value for FacebookKey not found")
    
    state = .loading
    let fbLoginManager = FBSDKLoginManager()
    //Logs out before login, in case user changes facebook accounts
    fbLoginManager.logOut()
    fbLoginManager.logIn(withReadPermissions: ["email"],
                         from: viewController,
                         handler: checkFacebookLoginRequest)
  }

  func signIn() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signIn, with: .push)
  }

  func signUp() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signUp, with: .push)
  }
  
  // MARK: Facebook callback methods
  
  func facebookLoginRequestSucceded() {
    //Optionally store params (facebook user data) locally.
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    //This fails with 404 since this endpoint is not implemented in the API base
    UserService.sharedInstance.loginWithFacebook(token: FBSDKAccessToken.current().tokenString,
                              success: { [weak self] in
                                self?.state = .idle
                                AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
                              },
                              failure: { [weak self] error in
                                self?.state = .error(error.localizedDescription)
                              })
  }
  
  func facebookLoginRequestFailed(reason: String, cancelled: Bool = false) {
    state = cancelled ? .idle : .error(reason)
  }
  
  func checkFacebookLoginRequest(result: FBSDKLoginManagerLoginResult?, error: Error?) {
    guard let result = result, error == nil else {
      facebookLoginRequestFailed(reason: error!.localizedDescription)
      return
    }
    if result.isCancelled {
      facebookLoginRequestFailed(reason: "User cancelled", cancelled: true)
    } else if !result.grantedPermissions.contains("email") {
      facebookLoginRequestFailed(reason: "It seems that you haven't allowed Facebook to provide your email address.")
    } else {
      facebookLoginRequestSucceded()
    }
  }
}
