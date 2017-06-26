//
//  SignUpViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    showSpinner(message: "VC spinner")
    UserServiceManager.signup("toptiertest@gmail.com", password: "123456789", success: { (responseObject) in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }) { (error) in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    }
  }
}
