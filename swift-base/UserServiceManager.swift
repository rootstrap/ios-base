//
//  UserServiceManager.swift
//  swift-base
//
//  Created by TopTier labs on 16/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserServiceManager {
    
    private class func getUsersUrl() -> String {
        return "/users/"
    }

    class func login(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
        let url = getUsersUrl() + "sign_in"
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

    class func signup(email email: String, password: String, success:(responseObject: String?) -> Void, failure: (error: NSError) -> Void) {
        let url = getUsersUrl()
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
