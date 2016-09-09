//
//  GeneralHelper.swift
//  swift-base
//
//  Created by TopTier labs on 2/19/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class UIHelper {
  
  //MARK: Message Error
  class func showMessageError(viewController viewController: UIViewController, title: String, errorMessage: String) {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
  }
  
  //MARK: Spinner
  class func showSpinner(view: UIView) -> MBProgressHUD {
    let spinningActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
    spinningActivity.labelText = NSLocalizedString("Please Wait", comment: "")
    spinningActivity.userInteractionEnabled = false
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    return spinningActivity
  }
  
  class func hideSpinner(spinningAct: MBProgressHUD) {
    spinningAct.hide(true)
    UIApplication.sharedApplication().endIgnoringInteractionEvents()
  }
  
  //MARK: Customize Views
  class func stylizePlaceholdersFor(targets: [UITextField], color: UIColor = UIColor.lightGrayColor()) {
    for textField in targets {
      textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSForegroundColorAttributeName: color])
    }
  }
}
