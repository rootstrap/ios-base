//
//  HomeViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    view.showSpinner(message: "View spinner")
    UserServiceManager.logout({
      self.hideSpinner()
      _ = self.navigationController?.popToRootViewController(animated: true)
    }) { (error) in
      self.hideSpinner()
      print(error)
    }
  }
}
