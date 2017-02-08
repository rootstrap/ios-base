//
//  ViewController.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON

class ViewController: UIViewController {

  @IBOutlet weak var testView: UIView!
  @IBOutlet weak var textView: PlaceholderTextView!

  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    testView.addBorder()
    testView.setRoundBorders()
    textView.addBorder(color: textView.placeholderColor!, weight: 1.0)
  }

  //MARK: Actions
  @IBAction func facebookLogin() {
    showSpinner()
    let fbLoginManager = FBSDKLoginManager()
    //Logs out before login, in case user changes facebook accounts
    fbLoginManager.logOut()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
      guard error == nil else {
        self.showMessageError(title: "Oops..", errorMessage: "Something went wrong, try again later.")
        self.hideSpinner()
        return
      }
      if result?.grantedPermissions == nil || result?.isCancelled ?? true {
        self.hideSpinner()
      } else if !(result?.grantedPermissions.contains("email"))! {
        self.hideSpinner()
        self.showMessageError(title: "Oops..", errorMessage: "It seems that you haven't allowed Facebook to provide your email address.")
      } else {
        self.facebookLoginCallback()
      }
    }
  }

  @IBAction func tapOnSignUp(_ sender: Any) {
    showSpinner(message: "VC spinner")
    UserServiceManager.signup("toptier@mail.com", password: "123456789", success: { (responseObject) in
      print("\(responseObject)")
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
      print("\(responseObject)")
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
    //Optionally store params (facebook user data) locally.
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    UserServiceManager.loginWithFacebook(token: FBSDKAccessToken.current().tokenString,
     success: { _ -> Void in
      self.hideSpinner()
      self.performSegue(withIdentifier: "goToMainView", sender: nil)
    }) { (error) -> Void in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error._domain)
    }
  }
}
