//
//  ButtonExtension.swift
//  ios-base
//
//  Created by Karen Stoletniy on 12/7/21.
//  Copyright © 2021 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  
  static func primaryButton(
    color: UIColor = .buttonBackground,
    title: String = "",
    titleColor: UIColor = .white,
    cornerRadius: CGFloat = UI.Button.cornerRadius,
    height: CGFloat = UI.Button.height,
    font: UIFont = .h3Medium,
    target: Any? = nil,
    action: Selector? = nil
  ) -> UIButton {
    let button = UIButton()
    button.setup(
      color: color,
      title: title,
      titleColor: titleColor,
      cornerRadius: cornerRadius,
      height: height,
      font: font
    )
    if let action = action {
      button.addTarget(target, action: action, for: .touchUpInside)
    }
    return button
  }
  
  private func setup(
    color: UIColor = .buttonBackground,
    title: String = "",
    titleColor: UIColor = .white,
    cornerRadius: CGFloat = UI.Button.cornerRadius,
    height: CGFloat = UI.Button.height,
    font: UIFont = .h3Medium
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    setTitle(title, for: .normal)
    setTitleColor(titleColor, for: .normal)
    backgroundColor = color
    titleLabel?.font = font
    setRoundBorders(cornerRadius)
    heightAnchor.constraint(equalToConstant: height).isActive = true
  }
}
