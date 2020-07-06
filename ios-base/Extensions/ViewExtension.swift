//
//  UIViewExtension.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  // MARK: - Instance methods
  //Change the default values for params as you wish
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    layer.borderColor = color.cgColor
    layer.borderWidth = weight
  }
  
  func setRoundBorders(_ cornerRadius: CGFloat = 10.0) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
  }
  
  var typeName: String {
    return String(describing: type(of: self))
  }
  
  func instanceFromNib(withName name: String) -> UIView? {
    return UINib(nibName: name,
                 bundle: nil).instantiate(withOwner: self,
                                          options: nil).first as? UIView
  }
  
  func addNibView(
    withNibName nibName: String? = nil,
    withAutoresizingMasks masks: AutoresizingMask = [.flexibleWidth, .flexibleHeight]
  ) -> UIView {
    let name = String(describing: type(of: self))
    guard let view = instanceFromNib(withName: nibName ?? name) else {
        assert(false, "No nib found with that name")
        return UIView()
    }
    view.frame = bounds
    view.autoresizingMask = masks
    addSubview(view)
    return view
  }
  
  func animateChangeInLayout(withDuration duration: TimeInterval = 0.2) {
    setNeedsLayout()
    UIView.animate(withDuration: duration, animations: { [weak self] in
      self?.layoutIfNeeded()
    })
  }
}

extension Array where Element: UIView {
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    for view in self {
      view.addBorder(color: color, weight: weight)
    }
  }
  
  func roundBorders(cornerRadius: CGFloat = 10.0) {
    for view in self {
      view.setRoundBorders(cornerRadius)
    }
  }
}
