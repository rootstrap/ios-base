//
//  GeneralHelper.swift
//  ios-base
//
//  Created by Rootstrap on 2/19/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
  // MARK: - Customize Views
  class func stylizePlaceholdersFor(_ targets: [UITextField], color: UIColor = UIColor.lightGray) {
    for textField in targets {
      textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
  }
}
