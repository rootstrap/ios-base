//
//  UITextFieldExtension.swift
//  ios-base
//
//  Created by German on 9/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import UIKit

extension UITextField {
  func setPlaceholder(color: UIColor = .lightGray) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: color]
    )
  }
}
