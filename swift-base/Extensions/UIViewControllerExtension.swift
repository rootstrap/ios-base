//
//  UIViewControllerExtension.swift
//  swift-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    //MARK: Message Error
    func showMessageError(title: String, errorMessage: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: Spinner
    func showSpinner(view: UIView, message: String? = "Please Wait", comment: String? = "") -> MBProgressHUD {
        let spinningActivity = MBProgressHUD.showAdded(to: view, animated: true)
        spinningActivity.label.text = NSLocalizedString(message!, comment: comment!)
        spinningActivity.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        return spinningActivity
    }

    func hide(spinner: MBProgressHUD) {
        spinner.hide(animated: true)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
