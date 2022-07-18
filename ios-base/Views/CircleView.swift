//
//  CircleView.swift
//  ios-base
//
//  Created by Lucas Miotti on 13/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
  
  override func draw(_ rect: CGRect) {
    view.layer.cornerRadius = view.layer.bounds.width / 2
    view.clipsToBounds = true
  }
}
