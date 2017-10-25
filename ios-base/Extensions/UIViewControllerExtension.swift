//
//  UIViewControllerExtension.swift
//  ios-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  //MARK: Message Error
  func showMessageError(title: String, errorMessage: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
}
