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
  func addBorder(color: UIColor = UIColor.blackColor(), weight: CGFloat = 1.0) {
    self.layer.borderColor = color.CGColor
    self.layer.borderWidth = weight
  }
  
  func setRoundBorders(cornerRadius: CGFloat = 10.0) {
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadius
  }
  
  //MARK: Class methods
  //Change the default values for params as you wish
  class func addBorderTo(targets: [UIView], color: UIColor = UIColor.blackColor(), weight: CGFloat = 1.0) {
    for view in targets {
      view.addBorder(color, weight: weight)
    }
  }
  
  class func roundBordersOf(targets: [UIView], cornerRadius: CGFloat = 10.0) {
    for view in targets {
      view.setRoundBorders(cornerRadius)
    }
  }
}
