//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, ActivityIndicatorPresenter {
  
  // MARK: - Outlets
  
//  @IBOutlet weak var signUp: UIButton!
//  @IBOutlet weak var emailField: UITextField!
//  @IBOutlet weak var passwordField: UITextField!
//  @IBOutlet weak var passwordConfirmationField: UITextField!
  
  private lazy var titleLabel = UILabel.titleLabel(text: "Sign Up")
  private lazy var signUpButton = UIButton.primaryButton(
    title: "SIGN UP",
    target: self,
    action: #selector(tapOnSignUpButton)
  )
  private lazy var emailField = UITextField.primaryTextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "Email"
  )
  private lazy var passwordField = UITextField.primaryTextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "Password"
  )
  private lazy var passwordConfirmationField = UITextField.primaryTextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "Confirm Password"
  )
  
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: SignUpViewModelWithEmail!
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.delegate = self
    setSignUpButton(enabled: false)
    configureViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  
  @objc
  func formEditingChange(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    case passwordConfirmationField:
      viewModel.passwordConfirmation = newValue
    default: break
    }
  }
  
  @objc
  func tapOnSignUpButton(_ sender: Any) {
    viewModel.signup()
  }
  
  func setSignUpButton(enabled: Bool) {
    signUpButton.alpha = enabled ? 1 : 0.5
    signUpButton.isEnabled = enabled
  }
}

private extension SignUpViewController {
  func configureViews() {
    applyDefaultUIConfigs()
    setSignUpButton(enabled: false)
    view.addSubviews(subviews: [
      titleLabel,
      emailField,
      passwordField,
      passwordConfirmationField,
      signUpButton
    ])
    
    activateConstrains()
  }
  
  func activateConstrains() {
    [
      titleLabel,
     emailField,
     passwordField,
     passwordConfirmationField,
     signUpButton
    ].forEach({
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
      passwordConfirmationField.topAnchor.constraint(
        equalTo: passwordField.bottomAnchor,
        constant: UI.Defaults.spacing
      ),
      signUpButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -UI.ViewController.bottomMargin
      )
    ])
  }
}

extension SignUpViewController: SignUpViewModelDelegate {
  func formDidChange() {
    setSignUpButton(enabled: viewModel.hasValidData)
  }
}
