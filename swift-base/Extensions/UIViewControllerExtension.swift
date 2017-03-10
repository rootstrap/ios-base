//
//  UIViewControllerExtension.swift
//  swift-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  //MARK: Message Error
  func showMessageError(title: String, errorMessage: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  
  func showSpinner(message: String = "Please Wait", comment: String = "") {
    view.showSpinner(message: message, comment: comment)
  }
  
  func hideSpinner() {
    view.hideSpinner()
  }
}
