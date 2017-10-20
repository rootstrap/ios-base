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
    UserAPI.getMyProfile({ (json) in
      print(json)
    }, failure: { error in
      print(error)
    })
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    Spinner.show()
    UserAPI.logout({
      Spinner.hide()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
    }, failure: { error in
      Spinner.hide()
      print(error)
    })
  }
}
