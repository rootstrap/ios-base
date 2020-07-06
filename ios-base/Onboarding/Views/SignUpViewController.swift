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
  
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: SignUpViewModelWithEmail!
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUp.setRoundBorders(22)
    viewModel.delegate = self
    setSignUpButton(enabled: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func formEditingChange(_ sender: UITextField) {
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
  
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    viewModel.signup()
  }
  
  func setSignUpButton(enabled: Bool) {
    signUp.alpha = enabled ? 1 : 0.5
    signUp.isEnabled = enabled
  }
}

extension SignUpViewController: SignUpViewModelDelegate {
  func formDidChange() {
    setSignUpButton(enabled: viewModel.hasValidData)
  }
}
