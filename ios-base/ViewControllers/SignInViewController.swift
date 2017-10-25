//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    UIApplication.showNetworkActivity()
    UserAPI.login("rootstrap@gmail.com", password: "123456789", success: { _ in
      UIApplication.hideNetworkActivity()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      self.showMessageError(title: "Error", errorMessage: error.localizedDescription)
      print(error)
    })
  }
}
