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
    func showMessageError(title: String, errorMessage: String, handler: ((_action: UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //MARK: Spinner
    func showSpinner(view: UIView, message: String? = "Please Wait", comment :String? = "") -> MBProgressHUD {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
        spinningActivity.labelText = NSLocalizedString(message!, comment: comment!)
        spinningActivity.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        return spinningActivity
    }

    func hideSpinner(spinningAct: MBProgressHUD) {
        spinningAct.hide(true)
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}
