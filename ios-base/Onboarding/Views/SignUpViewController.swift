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
  
  private lazy var titleLabel = UILabel.titleLabel(text: "signup_title".localized)
  private lazy var signUpButton = UIButton.primaryButton(
    title: "signup_button_title".localized,
    target: self,
    action: #selector(tapOnSignUpButton)
  )
  
  private lazy var emailField = UITextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "signup_email_placeholder".localized
  )
  
  private lazy var passwordField = UITextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "signup_password_placeholder".localized,
    isPassword: true
  )
  
  private lazy var passwordConfirmationField = UITextField(
    target: self,
    selector: #selector(formEditingChange),
    placeholder: "signup_confirm_password_placeholder".localized,
    isPassword: true
  )
  
  let activityIndicator = UIActivityIndicatorView()
  
  private let viewModel: SignUpViewModelWithEmail
  
  init(viewModel: SignUpViewModelWithEmail) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    ].forEach {
      $0.attachHorizontally(to: view)
    }
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
