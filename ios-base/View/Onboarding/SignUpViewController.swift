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
    viewModel.onFormChange = { [unowned self] in
      self.signUp.isEnabled = self.viewModel.hasValidData
    }
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
    UIApplication.showNetworkActivity()
    viewModel.signup(success: { [unowned self] in
      UIApplication.hideNetworkActivity()
      let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
      UIApplication.shared.keyWindow?.rootViewController = homeVC
    }, failure: { [unowned self] failureReason in
      UIApplication.hideNetworkActivity()
      self.showMessage(title: "Error", message: failureReason)
    })
  }
}
