//
//  LoginViewController.swift
//  ios-base
//
//  Created by Lucas Miotti on 11/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate {
  
  private var viewModel: LoginViewModel
  
  private lazy var header = UIImageView(image: UIImage(named: "Auth Header"))
  
  private lazy var titleLabel = UILabel.titleLabel(
    text: "TARGET MVD",
    font: UIFont.boldSystemFont(ofSize: 20),
    textColor: UIColor.black,
    numberOfLines: 1,
    textAlignment: .center
  )
  
  private lazy var emailFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(title: "EMAIL")
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var passwordFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "PASSWORD",
      error: "this email and password don’t match"
    )
    form.secureTextEntry = true
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private var signInButton = UIButton.primaryButton(
    color: UIColor.black,
    title: "SIGN IN",
    titleColor: .white,
    cornerRadius: 0,
    height: 37,
    font: UIFont.font(size: .heading5),
    action: #selector(tapOnButton)
  )
  
  private lazy var forgotPasswordButton = UIButton.primaryButton(
    color: UIColor.white,
    title: "Forgot your password?",
    titleColor: UIColor.black,
    cornerRadius: 0,
    height: 14,
    font: UIFont.font(size: .heading5)
  )
  
  private lazy var facebookButton = UIButton.primaryButton(
    color: UIColor.white,
    title: "CONNECT WITH FACEBOOK",
    titleColor: UIColor.black,
    cornerRadius: 0,
    height: 14,
    font: UIFont.boldSystemFont(ofSize: 12),
    action: #selector(tapOnButton)
  )
  
  private lazy var container: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      emailFormField,
      passwordFormField,
      signInButton
    ])
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var dividerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var signUpButton = UIButton.primaryButton(
    color: .white,
    title: "SIGN UP",
    titleColor: .black,
    cornerRadius: 0,
    height: 15,
    action: #selector(tapOnButton)
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    configureConstraints()
    configureConstraints2()
    viewModel.delegate = self
  }
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureViews() {
    view.backgroundColor = .white
    // facebookButton.permissions = ["public_profile","email"]
    view.addSubviews(subviews: [
      header,
      titleLabel,
      container,
      forgotPasswordButton,
      facebookButton,
      dividerView,
      signUpButton
    ])
  }
  
  private func configureConstraints() {
    [
      titleLabel,
      container,
      forgotPasswordButton,
      facebookButton,
      dividerView,
      signUpButton
    ].forEach {
      $0.centerHorizontally(with: view)
    }

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: 75
      ),
      container.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 75
      ),
      container.widthAnchor.constraint(equalToConstant: 188),
      signInButton.widthAnchor.constraint(equalToConstant: 114),
      forgotPasswordButton.topAnchor.constraint(
        equalTo: signInButton.bottomAnchor,
        constant: 11
      ),
      facebookButton.topAnchor.constraint(
        equalTo: forgotPasswordButton.bottomAnchor,
        constant: 22
      )
    ])
  }
  
  private func configureConstraints2() {
    NSLayoutConstraint.activate([
      dividerView.widthAnchor.constraint(equalToConstant: 121),
      dividerView.heightAnchor.constraint(equalToConstant: 0.5),
      dividerView.bottomAnchor.constraint(
        equalTo: signUpButton.topAnchor,
        constant: -15.5
      ),
      signUpButton.widthAnchor.constraint(equalToConstant: 102),
      signUpButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -45
      )
    ])
  }
  
  @objc
  func tapOnButton(_ sender: UIButton) {
    if sender == signInButton {
      viewModel.signIn()
    } else if sender == facebookButton {
      viewModel.facebookSignIn()
    } else {
      AppNavigator.shared.navigate(
        to: OnboardingRoutes.register,
        with: TransitionType.changeRoot
      )
    }
  }
  
  func showFieldError(_ sender: UIFormFieldView) {
    sender.toggleErrorState(isError: true)
  }
  
  func onTextChanged(_ sender: UIFormFieldView) {
    passwordFormField.toggleErrorState(isError: false)
    emailFormField.toggleErrorState(isError: false)
    if (sender == emailFormField) {
      viewModel.email = sender.text
    } else {
      viewModel.password = sender.text
    }
  }
  
  func showEmailError() {
    emailFormField.toggleErrorState(isError: true)
  }
  
  func showPasswordError() {
    passwordFormField.toggleErrorState(isError: true)
  }
  
  func onAuthSuccess() {
    AppNavigator.shared.navigate(
      to: OnboardingRoutes.home,
      with: TransitionType.changeRoot
    )
  }
  
  func onAuthError(errorCode: String) {
    let alert = UIAlertController(
      title: "Uh oh!",
      message: "Something went wrong. Error code: \(errorCode)",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        // Cancel Action
    }))
    self.present(alert, animated: true, completion: nil)
  }
}
