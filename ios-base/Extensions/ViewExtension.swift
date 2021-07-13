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
  
  // MARK: Constrains Helper
  
  func attachHorizontally(
    subview: UIView,
    leadingMargin: CGFloat = UI.Defaults.margin,
    trailingMargin: CGFloat = UI.Defaults.margin
  ) {
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
      subview.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -trailingMargin
      )
    ])
  }
  
  func addSubviews(subviews: [UIView]) {
    for subview in subviews {
      addSubview(subview)
    }
  }
  
  func attachVertically(
    subview: UIView,
    topMargin: CGFloat = UI.Defaults.margin,
    bottomMargin: CGFloat = UI.Defaults.margin
  ) {
    NSLayoutConstraint.activate([
      subview.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
      subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomMargin)
    ])
  }
  
  func center(
    subview: UIView,
    verticalOffset: CGFloat = 0,
    horizontalOffset: CGFloat = 0,
    vertically: Bool = true,
    horizontally: Bool = true
  ) {
    if vertically {
      subview.centerYAnchor.constraint(
        equalTo: centerYAnchor,
        constant: verticalOffset
      ).isActive = true
    }
    
    if horizontally {
      subview.centerXAnchor.constraint(
        equalTo: centerXAnchor,
        constant: horizontalOffset
      ).isActive = true
    }
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
