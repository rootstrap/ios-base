//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  var viewModel = SignInViewModelWithCredentials()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
    viewModel.delegate = self
    enableLoginButton(false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func credentialsChanged(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    default: break
    }
  }
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    viewModel.login()
  }
  
  func setLoggedInRoot() {
    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    UIApplication.shared.keyWindow?.rootViewController = homeVC
  }
  
  func enableLoginButton(_ enabled: Bool) {
    logIn.alpha = enabled ? 1 : 0.5
    logIn.isEnabled = enabled
  }
}

extension SignInViewController: SignInViewModelDelegate {
  func didUpdateCredentials() {
    enableLoginButton(viewModel.hasValidCredentials)
  }
  
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Error", message: errorDescription)
    case .loggedIn:
      UIApplication.hideNetworkActivity()
      setLoggedInRoot()
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}
