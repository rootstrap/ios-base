//
//  LabelExtension.swift
//  ios-base
//
//  Created by Karen Stoletniy on 12/7/21.
//  Copyright © 2021 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  
  static func titleLabel (
    text: String = "",
    font: UIFont = .h1Regular,
    textColor: UIColor = .mainTitle,
    backgroundColor: UIColor = .clear,
    numberOfLines: Int = 0,
    textAlignment: NSTextAlignment = .left
  ) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.font = font
    label.textColor = textColor
    label.backgroundColor = backgroundColor
    label.numberOfLines = numberOfLines
    label.textAlignment = textAlignment
    
    return label
  }
}
