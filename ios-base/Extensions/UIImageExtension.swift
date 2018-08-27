//
//  UIImageExtension.swift
//  ios-base
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  class func random(size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
    let rr = CGFloat(arc4random_uniform(255))
    let rg = CGFloat(arc4random_uniform(255))
    let rb = CGFloat(arc4random_uniform(255))
    let color = UIColor(red: rr/255, green: rg/255, blue: rb/255, alpha: 1.0)
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.addRect(CGRect(origin: .zero, size: size))
    context?.fillPath()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
