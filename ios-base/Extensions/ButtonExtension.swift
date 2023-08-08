//
//  ButtonExtension.swift
//  ios-base
//
//  Created by Karen Stoletniy on 12/7/21.
//  Copyright © 2021 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

struct ButtonProperties {
  var color: UIColor = .buttonBackground
  var title: String = ""
  var accessibilityIdentifier: String = ""
  var titleColor: UIColor = .white
  var cornerRadius: CGFloat = UI.Button.cornerRadius
  var height: CGFloat = UI.Button.height
  var font: UIFont = .h3Medium
  var target: Any?
  var action: Selector?
}

extension UIButton {
  
  static func primaryButton(properties: ButtonProperties) -> UIButton {
    let button = UIButton()
    button.setup(
      color: properties.color,
      title: properties.title,
      identifier: properties.accessibilityIdentifier,
      titleColor: properties.titleColor,
      cornerRadius: properties.cornerRadius,
      height: properties.height,
      font: properties.font
    )
    if let action = properties.action {
      button.addTarget(properties.target, action: action, for: .touchUpInside)
    }
    return button
  }
  
  private func setup(
    color: UIColor = .buttonBackground,
    title: String = "",
    identifier: String = "",
    titleColor: UIColor = .white,
    cornerRadius: CGFloat = UI.Button.cornerRadius,
    height: CGFloat = UI.Button.height,
    font: UIFont = .h3Medium
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    setTitle(title, for: .normal)
    accessibilityIdentifier = identifier
    setTitleColor(titleColor, for: .normal)
    backgroundColor = color
    titleLabel?.font = font
    setRoundBorders(cornerRadius)
    heightAnchor.constraint(equalToConstant: height).isActive = true
  }
}
