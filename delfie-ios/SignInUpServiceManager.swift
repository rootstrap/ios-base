//
//  SignInUpServiceManager.swift
//  delfie-ios
//
//  Created by TopTier labs on 16/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class SignInUpServiceManager {

    class func loginUser(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
        let url = "/users/sign_in"
        let parameters = [
            "user": [
                "email": email,
                "password": password
            ]
        ]
        CommunicationManager.sendPostRequest(url: url, params: parameters,
            success: { (responseObject) -> Void in
                success(responseObject: "")
            }) { (error) -> Void in
                failure(error: error)
        }
    }

    class func signupUser(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
        let url = "/users/"
        let parameters = [
            "user": [
                "email": email,
                "password": password,
                "password_confirmation": password
            ]
        ]
        CommunicationManager.sendPostRequest(url: url, params: parameters,
            success: { (responseObject) -> Void in
                success(responseObject: "")
            }) { (error) -> Void in
                failure(error: error)
        }
    }

}
