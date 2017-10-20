//
//  GeneralHelper.swift
//  swift-base
//
//  Created by TopTier labs on 2/19/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
  //MARK: Customize Views
  class func stylizePlaceholdersFor(_ targets: [UITextField], color: UIColor = UIColor.lightGray) {
    for textField in targets {
      textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSForegroundColorAttributeName: color])
    }
  }
}
