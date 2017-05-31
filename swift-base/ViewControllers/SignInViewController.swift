//
//  SignInViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    view.showSpinner(message: "View spinner")
    UserServiceManager.login("toptier@mail.com", password: "123456789", success: { (responseObject) in
      self.hideSpinner()
      if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }) { (error) in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    }
  }
}
