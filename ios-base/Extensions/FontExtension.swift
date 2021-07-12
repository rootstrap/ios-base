//
//  FontExtension.swift
//  ios-base
//
//  Created by Germán Stábile on 2/28/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import UIKit
import RSFontSizes

extension UIFont {
  static let h1Regular: UIFont = .systemFont(ofSize: 32, weight: .regular)
  static let h2Regular: UIFont = .systemFont(ofSize: 16, weight: .regular)
  static let h3Regular: UIFont = .systemFont(ofSize: 15, weight: .regular)
  static let h1Medium: UIFont = .systemFont(ofSize: 32, weight: .medium)
  static let h2Medium: UIFont = .systemFont(ofSize: 16, weight: .medium)
  static let h3Medium: UIFont = .systemFont(ofSize: 15, weight: .medium)
  
  private func withWeight(_ weight: UIFont.Weight) -> UIFont {
    var attributes = fontDescriptor.fontAttributes
    var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
    
    traits[.weight] = weight
    
    attributes[.name] = nil
    attributes[.traits] = traits
    attributes[.family] = familyName
    
    let descriptor = UIFontDescriptor(fontAttributes: attributes)
    
    return UIFont(descriptor: descriptor, size: pointSize)
  }
  
  static func font(withName name: String, size: CGFloat) -> UIFont {
    let size = Font.PointSize.proportional(to: (.screen6_5Inch,
                                                size)).value()
    let font = UIFont(name: name,
                      size: size)
    return font ?? UIFont.systemFont(ofSize: size)
  }
}
