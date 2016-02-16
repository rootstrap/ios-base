//
//  ViewController.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserServiceManager.signup(email: "hello@hello.com", password: "123456789",
            success: { (responseObject) -> Void in
                print("Success")
            }) { (error) -> Void in
                print("Error")
        }
        UserServiceManager.login(email: "hello@hello.com", password: "123456789",
            success: { (responseObject) -> Void in
                print("Success")
            }) { (error) -> Void in
                print("Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
