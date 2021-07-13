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
  static let h1Regular: UIFont = .font(size: 32).withWeight(.regular)
  static let h2Regular: UIFont = .font(size: 16).withWeight(.regular)
  static let h3Regular: UIFont = .font(size: 15).withWeight(.regular)
  static let h1Medium: UIFont = .font(size: 32).withWeight(.medium)
  static let h2Medium: UIFont = .font(size: 16).withWeight(.regular)
  static let h3Medium: UIFont = .font(size: 15).withWeight(.regular)
  
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
  
  static func font(withName name: String = "", size: CGFloat) -> UIFont {
    let size = Font.PointSize.proportional(to: (.screen6_5Inch,
                                                size)).value()
    let font = UIFont(name: name,
                      size: size)
    return font ?? UIFont.systemFont(ofSize: size)
  }
}
