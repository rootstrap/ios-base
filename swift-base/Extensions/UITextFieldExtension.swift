//
//  UITextFieldExtension.swift
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  //MARK: Instance methods
  func addLeftPadding(width: CGFloat = 8.0) {
    let rect = CGRect(x: 0, y: 0, width: width, height: frame.height)
    let paddingView = UIView(frame: rect)
    leftView = paddingView
    leftViewMode = .always
  }
  
  //MARK: Class methods
  class func addLeftPadding(of targets: [UITextField], width: CGFloat = 8.0) {
    for field in targets {
      field.addLeftPadding(width: width)
    }
  }
}
