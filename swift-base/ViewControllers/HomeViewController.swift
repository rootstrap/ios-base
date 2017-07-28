//
//  HomeViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var message: UILabel!
  @IBOutlet weak var info: UILabel!
  @IBOutlet weak var getProfile: UIButton!
  @IBOutlet weak var logOut: UIButton!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    
    message.text = "You are logged in/ \nsigned up".localize()
    getProfile.setTitle("Try get my profile".localize(), for: .normal)
    logOut.setTitle("Log Out".localize(), for: .normal)
  }
  
  // MARK: - Actions
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    UserAPI.getMyProfile({ (json) in
      self.info.text = json.rawString()
      self.info.setSpacing(ofLine: 3, ofCharacter: 1)
      print(json)
    }) { (error) in
      self.info.text = error.localizedDescription
      print(error)
    }
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    view.showSpinner(message: "Logging Out")
    UserAPI.logout({
      self.logOutResponse()
    }) { (error) in
      self.logOutResponse()
      print(error)
    }
  }
  
  func logOutResponse() {
    hideSpinner()
    UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
  }
}
