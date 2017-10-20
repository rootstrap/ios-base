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
    Spinner.show()
    UserAPI.login("toptier@mail.com", password: "123456789", success: { _ in
      Spinner.hide()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      Spinner.hide()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    })
  }
}
