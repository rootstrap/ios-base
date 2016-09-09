//
//  ViewController.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MBProgressHUD

class ViewController: UIViewController {
  
  @IBOutlet weak var testView: UIView!
  
  var spinningActivity: MBProgressHUD!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UserServiceManager.signup(email: "hello@hello.com", password: "123456789", success: { (responseObject) -> Void in
      print("Success")
    }) { (error) -> Void in
      print("Error")
    }
    UserServiceManager.login(email: "hello@hello.com", password: "123456789", success: { (responseObject) -> Void in
      print("Success")
    }) { (error) -> Void in
      print("Error")
    }
    testView.addBorder()
    testView.setRoundBorders()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func facebookLogin() {
    spinningActivity = UIHelper.showSpinner(self.view)
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
      guard error == nil else {
        return
      }
      if result.grantedPermissions != nil && result.grantedPermissions.contains("email") {
        self.facebookLoginCallback()
      }
      if result.isCancelled {
        UIHelper.hideSpinner(self.spinningActivity)
      }
    }
  }
  
  //MARK: Facebook callback methods
  func facebookLoginCallback() {
    guard FBSDKAccessToken.currentAccessToken() != nil else {
      return
    }
    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler ({ (connection, result, error) -> Void in
      guard error == nil else {
        return
      }
      let firstName = result.valueForKey("first_name") as? String ?? ""
      let lastName = result.valueForKey("last_name") as? String ?? ""
      let email = result.valueForKey("email") as? String ?? ""
      let facebookID = result.valueForKey("id") as? String ?? ""
      self.facebookSignIn(firstName: firstName, lastName: lastName, email: email, facebookID: facebookID)
    })
  }
  
  func facebookSignIn(firstName firstName: String, lastName: String, email: String, facebookID: String) {
    UserServiceManager.loginWithFacebook(email: email, firstName: firstName, lastName: lastName, facebookId: facebookID, success: { (responseObject) -> Void in
      UserDataManager.storeSessionToken(responseObject)
      UIHelper.hideSpinner(self.spinningActivity)
      print("perform segue")
      //TODO: perform segue
    }) { (error) -> Void in
      UIHelper.hideSpinner(self.spinningActivity)
      UIHelper.showMessageError(viewController: self, title: "Error", errorMessage: error.domain)
    }
  }
  
}
