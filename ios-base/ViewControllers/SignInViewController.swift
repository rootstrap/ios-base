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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    UIApplication.showNetworkActivity()
    let email = !emailField.text!.isEmpty ? emailField.text : "rootstrap@gmail.com"
    let password = !passwordField.text!.isEmpty ? passwordField.text : "123456789"
    
    UserAPI.login(email!, password: password!, success: { 
      UIApplication.hideNetworkActivity()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      self.showMessage(title: "Error", message: error.localizedDescription)
      print(error)
    })
  }
}
