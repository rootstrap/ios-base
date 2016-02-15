//
//  UserDataManager.swift
//  delfie-ios
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {

    var sessionToken: String?

    class func storeSessionToken(token: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: "sessionToken")
    }

    class func getSessionToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey("sessionToken") as? String
    }

}
