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
  @IBOutlet weak var textView: PlaceholderTextView!

  override func viewDidLoad() {
    super.viewDidLoad()

    testView.addBorder()
    testView.setRoundBorders()
    textView.addBorder(color: textView.placeholderColor!, weight: 1.0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: Actions

  @IBAction func facebookLogin() {
    showSpinner()
    let fbLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
      guard error == nil else {
        return
      }
      if result?.grantedPermissions != nil && (result?.grantedPermissions.contains("email"))! {
        self.facebookLoginCallback()
      }
      if result?.isCancelled ?? true {
        self.view.hideSpinner()
      }
    }
  }

  @IBAction func tapOnSignUp(_ sender: Any) {
    showSpinner(message: "VC spinner")
    UserServiceManager.signup("toptier@mail.com", password: "123456789", success: { (responseObject) in
      print(responseObject)
      self.hideSpinner()
    }) { (error) in
      self.hideSpinner()
      print(error)
    }
  }

  @IBAction func tapOnSignIn(_ sender: Any) {
    view.showSpinner(message: "View spinner")
    UserServiceManager.login("toptier@mail.com", password: "123456789", success: { (responseObject) in
      self.hideSpinner()
      print(responseObject)
    }) { (error) in
      self.hideSpinner()
      print(error)
    }
  }

  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    UserServiceManager.getMyProfile({ (json) in
      print(json)
    }) { (error) in
      print(error)
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
    //Optionally store params (facebook user data) locally.
    UserServiceManager.loginWithFacebook(email, firstName: firstName, lastName: lastName, facebookId: facebookID, token: FBSDKAccessToken.current().tokenString,
                                         success: { (responseObject) -> Void in
      self.hideSpinner()
      print("perform segue")
      //TODO: perform segue
    }) { (error) -> Void in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error._domain)
    }
  }
}
