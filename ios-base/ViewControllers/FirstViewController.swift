//
//  ViewController.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FirstViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var facebookSign: UIButton!
  @IBOutlet weak var signIn: UIButton!
  @IBOutlet weak var signUp: UIButton!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    [signIn, facebookSign].forEach({ $0?.setRoundBorders(22) })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Actions
  @IBAction func facebookLogin() {
    let facebookKey = ConfigurationManager.getValue(for: "FacebookKey")
    assert(facebookKey?.isEmpty ?? false, "Value for FacebookKey not found")
    
    UIApplication.showNetworkActivity()
    let fbLoginManager = FBSDKLoginManager()
    //Logs out before login, in case user changes facebook accounts
    fbLoginManager.logOut()
    fbLoginManager.logIn(withPublishPermissions: ["email"], from: self, handler: checkFacebookLoginRequest)
  }
  
  func checkFacebookLoginRequest(result: FBSDKLoginManagerLoginResult?, error: Error?) {
    guard let result = result, error == nil else {
      facebookLoginRequestFailed(reason: error!.localizedDescription)
      return
    }
    if result.isCancelled {
      self.facebookLoginRequestFailed(reason: "User cancelled", cancelled: true)
    } else if !result.grantedPermissions.contains("email") {
      facebookLoginRequestFailed(reason: "It seems that you haven't allowed Facebook to provide your email address.")
    } else {
      facebookLoginRequestSucceded()
    }
  }
  
  func facebookLoginRequestFailed(reason: String, cancelled: Bool = false) {
    if !cancelled {
      self.showMessage(title: "Oops..", message: reason)
    }
    UIApplication.hideNetworkActivity()
  }

  // MARK: Facebook callback methods
  func facebookLoginRequestSucceded() {
    //Optionally store params (facebook user data) locally.
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    UserAPI.loginWithFacebook(token: FBSDKAccessToken.current().tokenString,
     success: { 
      UIApplication.hideNetworkActivity()
      self.performSegue(withIdentifier: "goToMainView", sender: nil)
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      self.showMessage(title: "Error", message: error._domain)
    })
  }
}
