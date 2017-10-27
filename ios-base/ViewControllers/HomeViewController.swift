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
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    logOut.setRoundBorders(22)
  }
  
  // MARK: - Actions
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    UserAPI.getMyProfile({ (json) in
      let user = User.parse(fromJSON: json)
      self.showMessage(title: "Profile", message: "email: \(user.email)")
    }, failure: { error in
      print(error)
    })
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    UIApplication.showNetworkActivity()
    UserAPI.logout({
      self.logOutResponse()
    }, failure: { error in
      self.logOutResponse()
      print(error)
    })
  }
  
  func logOutResponse() {
    UIApplication.hideNetworkActivity()
    UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
  }
}
