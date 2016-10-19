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
import SwiftyJSON

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
    spinningActivity = showSpinner(view: self.view)
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
      guard error == nil else {
        return
      }
      if result?.grantedPermissions != nil && (result?.grantedPermissions.contains("email"))! {
        self.facebookLoginCallback()
      }
      if result?.isCancelled ?? true {
        self.hide(spinner: self.spinningActivity)
      }
    }
  }
  
  //MARK: Facebook callback methods
  func facebookLoginCallback() {
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start (completionHandler: { (connection, result, error) -> Void in
      guard error == nil && result != nil else {
        return
      }

      let json = JSON(result!)
      let firstName = json["first_name"].stringValue
      let lastName = json["lastName"].stringValue
      let email = json["email"].stringValue
      let facebookID = json["id"].stringValue
      self.facebookSignIn(firstName, lastName: lastName, email: email, facebookID: facebookID)
    })
  }
  
  func facebookSignIn(_ firstName: String, lastName: String, email: String, facebookID: String) {
    UserServiceManager.loginWithFacebook(email: email, firstName: firstName, lastName: lastName, facebookId: facebookID, success: { (responseObject) -> Void in
      UserDataManager.store(sessionToken: responseObject)
      self.hide(spinner: self.spinningActivity)
      print("perform segue")
      //TODO: perform segue
    }) { (error) -> Void in
      self.hide(spinner: self.spinningActivity)
      self.showMessageError(title: "Error", errorMessage: error._domain)
    }
  } 
}
