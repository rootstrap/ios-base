//
//  UIViewExtension.swift
//  swift-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  //MARK: Instance methods
  //Change the default values for params as you wish
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    layer.borderColor = color.cgColor
    layer.borderWidth = weight
  }
  
  func setRoundBorders(_ cornerRadius: CGFloat = 10.0) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
  }
  
  //MARK: Class methods
  //Change the default values for params as you wish
  class func addBorder(to targets: [UIView], color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    for view in targets {
      view.addBorder(color: color, weight: weight)
    }
  }
  
  class func roundBorders(of targets: [UIView], cornerRadius: CGFloat = 10.0) {
    for view in targets {
      view.setRoundBorders(cornerRadius)
    }
  }
  
  func showSpinner(message: String = "Please Wait", comment: String = "") {
    if let spinner = AppDelegate.shared.spinner {
      spinner.label.text = message.localize(comment: comment)
      spinner.center = center
      spinner.willMove(toSuperview: self)
      addSubview(spinner)
      spinner.show(animated: true)
      spinner.didMoveToSuperview()
      UIApplication.shared.beginIgnoringInteractionEvents()
    }
  }
  
  func hideSpinner() {
    if let spinner = AppDelegate.shared.spinner {
      spinner.willMove(toSuperview: nil)
      spinner.hide(animated: true)
      spinner.didMoveToSuperview()
    }
    UIApplication.shared.endIgnoringInteractionEvents()
  }
}
