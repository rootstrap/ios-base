//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, ActivityIndicatorPresenter {
  
  // MARK: - Outlets
  
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: SignInViewModelWithCredentials!
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
    viewModel.delegate = self
    setLoginButton(enabled: false)
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
  
  func setLoginButton(enabled: Bool) {
    logIn.alpha = enabled ? 1 : 0.5
    logIn.isEnabled = enabled
  }
}

extension SignInViewController: SignInViewModelDelegate {
  func didUpdateCredentials() {
    setLoginButton(enabled: viewModel.hasValidCredentials)
  }
}
