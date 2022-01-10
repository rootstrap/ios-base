//
//  UITextFieldExtension.swift
//  ios-base
//
//  Created by German on 9/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import UIKit

extension UITextField {
  static func primaryTextField(
    target: Any,
    selector: Selector,
    placeholder: String
  ) -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.addTarget(target, action: selector, for: .editingChanged)
    textField.placeholder = placeholder
    return textField
  }
  
  func setPlaceholder(color: UIColor = .lightGray) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: color]
    )
  }
}
