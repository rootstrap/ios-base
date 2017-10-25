//
//  UIStoryboardExtension.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 3/10/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func instantiateViewController <T: UIViewController>(_ type: T.Type, storyboardIdentifier: String = "Main") -> T? {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(type)
    }

    func instantiateViewController <T: UIViewController>(_ type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
