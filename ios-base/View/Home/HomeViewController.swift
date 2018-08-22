//
//  HomeViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var logOut: UIButton!
  
  var viewModel = HomeViewModel()
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    logOut.setRoundBorders(22)
  }
  
  // MARK: - Actions
  
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    viewModel.loadUserProfile(success: { [unowned self] email in
      self.showMessage(title: "My Profile", message: "email: \(email)")
    }, failure: { error in
      print("User Profile Error: " + error)
    })
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    UIApplication.showNetworkActivity()
    viewModel.logoutUser(success: { [unowned self] in
      UIApplication.hideNetworkActivity()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      print("User Logout Error: " + error)
    })
  }
}
