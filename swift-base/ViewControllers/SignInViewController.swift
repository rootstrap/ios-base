//
//  SignInViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var signIn: UIButton!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    for item in [name, email] {
      item?.addLeftPadding()
    }
    signIn.setRoundBorders(20)
  }
  
  // MARK: - Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    view.showSpinner(message: "View spinner")
    UserAPI.login("toptier@mail.com", password: "123456789", success: { (responseObject) in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }) { (error) in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    }
  }
}
