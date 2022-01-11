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
    placeholder: String,
    backgroundColor: UIColor = .white,
    height: CGFloat = UI.TextField.height,
    borderStyle: BorderStyle = .line
  ) -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.addTarget(target, action: selector, for: .editingChanged)
    textField.placeholder = placeholder
    textField.backgroundColor = backgroundColor
    textField.borderStyle = borderStyle
    textField.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    return textField
  }
  
  func setPlaceholder(color: UIColor = .lightGray) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: color]
    )
  }
}
