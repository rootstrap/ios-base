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
  
  //  @IBOutlet weak var logIn: UIButton!
  //  @IBOutlet weak var emailField: UITextField!
  //  @IBOutlet weak var passwordField: UITextField!
  
  private lazy var titleLabel = UILabel.titleLabel(text: "Sign In")
  private lazy var logInButton = UIButton.primaryButton(
    title: "Log In",
    target: self,
    action: #selector(tapOnSignInButton)
  )
  private lazy var emailField = UITextField.primaryTextField(
    target: self,
    selector: #selector(credentialsChanged),
    placeholder: "Email"
  )
  private lazy var passwordField = UITextField.primaryTextField(
    target: self,
    selector: #selector(credentialsChanged),
    placeholder: "Password"
  )
  
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: SignInViewModelWithCredentials!
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    
    configureViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  
  @objc func credentialsChanged(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    default: break
    }
  }
  
  @objc func tapOnSignInButton(_ sender: Any) {
    viewModel.login()
  }
  
  func setLoginButton(enabled: Bool) {
    logInButton.alpha = enabled ? 1 : 0.5
    logInButton.isEnabled = enabled
  }
}

private extension SignInViewController {
  func configureViews() {
    applyDefaultUIConfigs()
    setLoginButton(enabled: false)
    view.addSubviews(subviews: [
      titleLabel,
      emailField,
      passwordField,
      logInButton
    ])
    
    activateConstrains()
  }
  
  func activateConstrains() {
    [titleLabel, emailField, passwordField, logInButton].forEach({
      $0.attachHorizontally(to: view)
    })
    emailField.centerVertically(with: view)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: UI.ViewController.smallTopMargin
      ),
      passwordField.topAnchor.constraint(
        equalTo: emailField.bottomAnchor,
        constant: UI.Defaults.spacing
      ),
      logInButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -UI.ViewController.bottomMargin
      )
    ])
  }
}

extension SignInViewController: SignInViewModelDelegate {
  func didUpdateCredentials() {
    setLoginButton(enabled: viewModel.hasValidCredentials)
  }
}
