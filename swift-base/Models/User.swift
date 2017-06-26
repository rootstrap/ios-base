//
//  User.swift
//  swift-base
//
//  Created by TopTier labs on 1/18/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject, NSCoding {
  var id: Int
  var username: String?
  var email: String?
  var image: String?
  
  init(id: Int, username: String? = nil, email: String? = nil, image: String? = nil) {
    self.id = id
    self.username = username
    self.email = email
    self.image = image
  }
  
  required init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeInteger(forKey: "user-id")
    self.username = aDecoder.decodeObject(forKey: "user-username") as? String
    self.email = aDecoder.decodeObject(forKey: "user-email") as? String
    self.image = aDecoder.decodeObject(forKey: "user-image") as? String
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "user-id")
    aCoder.encode(self.username, forKey: "user-username")
    aCoder.encode(self.email, forKey: "user-email")
    aCoder.encode(self.image, forKey: "user-image")
  }
  
  //MARK Parser
  class func parse(fromJSON json: JSON) -> User {
    let user = json["user"]
    
    return User(id:       user["id"].intValue,
                username: user["full_name"].stringValue,
                email:    user["email"].stringValue,
                image:    user["profile_picture"].stringValue
    )
  }
}
