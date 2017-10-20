//
//  Spinner.swift
//  ios-base
//
//  Created by Agustina Chaer on 20/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

class Spinner {
  class func show() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  class func hide() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
