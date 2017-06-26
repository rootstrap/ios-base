//
//  HomeViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    UserServiceManager.getMyProfile({ (json) in
      print(json)
    }) { (error) in
      print(error)
    }
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    view.showSpinner(message: "View spinner")
    UserServiceManager.logout({
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
    }) { (error) in
      self.hideSpinner()
      print(error)
    }
  }
}
