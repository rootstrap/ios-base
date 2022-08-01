//
//  RegisterViewController.swift
//  ios-base
//
//  Created by Lucas Miotti on 19/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, RegisterDelegate {
  
  private var viewModel: RegisterViewModel
  
  private var genderPickerData: [String] = ["Male", "Female", "Non-binary"]
  
  private lazy var header = UIImageView(image: UIImage(named: "Auth Header"))
  
  private lazy var titleLabel = UILabel.titleLabel(
    text: "TARGET MVD",
    font: UIFont.boldSystemFont(ofSize: 20),
    textColor: UIColor.black,
    numberOfLines: 1,
    textAlignment: .center
  )
  
  private lazy var nameFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "NAME",
      error: "you forgot to put your name!"
    )
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var emailFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "EMAIL",
      error: "oops! this email is not valid"
    )
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var passwordFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "PASSWORD",
      placeholder: "MIN. 6 CHARACTER LONG",
      error: "the password must be 6 characters long"
    )
    form.secureTextEntry = true
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var confirmPasswordFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "CONFIRM PASSWORD",
      error: "passwords don’t match"
    )
    form.secureTextEntry = true
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var genderFormField: UIFormFieldView = {
    let form = UIFormFieldView()
    form.delegate = self
    form.setForm(
      title: "GENDER",
      placeholder: "SELECT YOUR GENDER",
      error: "You forgot to select your gender!"
    )
    form.setPicker(
      array: ["Male", "Female", "Non-binary"]
    )
    form.translatesAutoresizingMaskIntoConstraints = false
    return form
  }()
  
  private lazy var container: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      nameFormField,
      emailFormField,
      passwordFormField,
      confirmPasswordFormField,
      genderFormField
    ])
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private var signUpButton = UIButton.primaryButton(
    color: UIColor.black,
    title: "SIGN UP",
    titleColor: .white,
    cornerRadius: 0,
    height: 37,
    font: UIFont.font(size: .heading5),
    action: #selector(tapOnButton)
  )
  
  private lazy var dividerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var signInButton = UIButton.primaryButton(
    color: .white,
    title: "SIGN IN",
    titleColor: .black,
    cornerRadius: 0,
    height: 15,
    font: .font(size: UIFont.Sizes.heading5),
    action: #selector(tapOnButton)
  )
  
  init(viewModel: RegisterViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    configureConstraints()
    configureConstraints2()
    viewModel.delegate = self
  }
  
  private func configureViews() {
    view.backgroundColor = .white
    view.addSubviews(subviews: [
      header,
      titleLabel,
      container,
      signUpButton,
      dividerView,
      signInButton
    ])
  }
  
  private func configureConstraints() {
    NSLayoutConstraint.activate([
      header.heightAnchor.constraint(equalToConstant: 146.62),
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
      container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      container.bottomAnchor.constraint(equalTo: signUpButton.topAnchor),
      signUpButton.widthAnchor.constraint(equalToConstant: 114),
      signUpButton.topAnchor.constraint(
        equalTo: container.bottomAnchor,
        constant: 20
      ),
      dividerView.topAnchor.constraint(
        equalTo: signUpButton.bottomAnchor,
        constant: 19
      ),
      dividerView.widthAnchor.constraint(equalToConstant: 121),
      dividerView.heightAnchor.constraint(equalToConstant: 0.5),
      signInButton.topAnchor.constraint(
        equalTo: dividerView.bottomAnchor,
        constant: 15.5
      ),
      signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func configureConstraints2() {
    [
      header,
      titleLabel,
      container,
      signUpButton,
      dividerView,
      signInButton
    ].forEach {
      $0.centerHorizontally(with: view)
    }
  }

  func onTextChanged(_ sender: UIFormFieldView) {
    let input = sender.text
    switch sender {
    case nameFormField:
      viewModel.name = input
    case emailFormField:
      viewModel.email = input
    case passwordFormField:
      viewModel.password = input
    case confirmPasswordFormField:
      viewModel.confirmPassword = input
    default:
      viewModel.gender = input
    }
  }
  
  func showNameError() {
    nameFormField.toggleErrorState(isError: true)
  }
  
  func showEmailError() {
    emailFormField.toggleErrorState(isError: true)
  }
  
  func showPasswordError() {
    passwordFormField.toggleErrorState(isError: true)
  }

  func showConfirmPasswordError() {
    confirmPasswordFormField.toggleErrorState(isError: true)
  }
  
  func showGenderError() {
    genderFormField.toggleErrorState(isError: true)
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
 
  @objc
  func tapOnButton(_ sender: UIButton) {
    if sender == signInButton {
      AppNavigator.shared.navigate(
        to: OnboardingRoutes.login,
        with: TransitionType.changeRoot
      )
    } else {
      viewModel.signUp()
    }
  }
}
