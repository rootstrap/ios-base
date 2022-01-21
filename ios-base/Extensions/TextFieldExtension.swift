//
//  UITextFieldExtension.swift
//  ios-base
//
//  Created by German on 9/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import UIKit

extension UITextField {
  
  convenience init(
    target: Any,
    selector: Selector,
    placeholder: String,
    backgroundColor: UIColor = .white,
    height: CGFloat = UI.TextField.height,
    borderStyle: BorderStyle = .line,
    isPassword: Bool = false
  ) {
    self.init()
    
    translatesAutoresizingMaskIntoConstraints = false
    addTarget(target, action: selector, for: .editingChanged)
    self.placeholder = placeholder
    self.backgroundColor = backgroundColor
    self.borderStyle = borderStyle
    heightAnchor.constraint(equalToConstant: height).isActive = true
    isSecureTextEntry = isPassword
  }
  
  func setPlaceholder(color: UIColor = .lightGray) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: color]
    )
  }
}
