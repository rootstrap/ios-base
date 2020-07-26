//
//  ActivityIndicatorPresenter.swift
//  ios-base
//
//  Created by Germán Stábile on 5/21/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresenter: class {
  var activityIndicator: UIActivityIndicatorView { get }
  func showActivityIndicator(_ show: Bool)
}

extension ActivityIndicatorPresenter where Self: UIViewController {
  func showActivityIndicator(_ show: Bool) {
    view.isUserInteractionEnabled = !show
    
    guard show else {
      activityIndicator.removeFromSuperview()
      return
    }
    
    if activityIndicator.superview == nil {
      view.addSubview(activityIndicator)
    }
    activityIndicator.color = .black
    activityIndicator.frame = view.bounds
    activityIndicator.startAnimating()
  }
}
