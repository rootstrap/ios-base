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
  
  // MARK: - Lifecycle Event
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
    logIn.setTitle("LOG IN".localized, for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    view.showSpinner(message: "Logging In")
    let email = emailField.text!.isEmpty ? "rootstrap@gmail.com" : emailField.text
    let password = passwordField.text!.isEmpty ? "123456789" : passwordField.text
    
    UserAPI.login(email!, password: password!, success: { _ in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    })
  }
}
