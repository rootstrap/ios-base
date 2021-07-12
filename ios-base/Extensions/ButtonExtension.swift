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
  
  private func primaryButton(
    color: UIColor = .buttonBackground,
    title: String = "",
    titleColor: UIColor = .white,
    cornerRadius: CGFloat = UI.Button.cornerRadious,
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
