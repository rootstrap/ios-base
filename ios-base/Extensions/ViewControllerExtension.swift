//
//  UIViewControllerExtension.swift
//  ios-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  // MARK: - Message Error
  func showMessage(
    title: String, message: String,
    handler: ((_ action: UIAlertAction) -> Void)? = nil
  ) {
    let alert = UIAlertController(
      title: title, message: message, preferredStyle: UIAlertController.Style.alert
    )
    alert.addAction(
      UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler)
    )
    present(alert, animated: true, completion: nil)
  }
  
  func applyDefaultUIConfigs() {
    view.backgroundColor = .screenBackground
  }
}
