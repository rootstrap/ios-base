//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  
  var viewModel = SignUpViewModelWithEmail()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUp.setRoundBorders(22)
    viewModel.delegate = self
    enableSignUpButton(false)
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
  
  func setSignedUpRoot() {
    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    UIApplication.shared.keyWindow?.rootViewController = homeVC
  }
  
  func enableSignUpButton(_ enable: Bool) {
    signUp.alpha = enable ? 1 : 0.5
    signUp.isEnabled = enable
  }
}

extension SignUpViewController: SignUpViewModelDelegate {
  func formDidChange() {
    enableSignUpButton(viewModel.hasValidData)
  }
  
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .signedUp:
      UIApplication.hideNetworkActivity()
      setSignedUpRoot()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Error", message: errorDescription)
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}
