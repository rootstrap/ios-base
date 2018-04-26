//
//  User.swift
//  ios-base
//
//  Created by Rootstrap on 1/18/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject, NSCoding {
  var id: String
  var username: String
  var email: String
  var image: URL?
  
  init(id: String, username: String = "", email: String, image: String = "") {
    self.id = id
    self.username = username
    self.email = email
    self.image = URL(string: image)
  }
  
  convenience init(json: JSON) {
    self.init(id: json["id"].stringValue,
              username: json["username"].stringValue,
              email: json["email"].stringValue,
              image: json["profile_picture"].stringValue)
  }
  
  required init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeObject(forKey: "user-id") as? String ?? ""
    self.username = aDecoder.decodeObject(forKey: "user-username") as? String ?? ""
    self.email = aDecoder.decodeObject(forKey: "user-email") as? String ?? ""
    self.image = URL(string: aDecoder.decodeObject(forKey: "user-image") as? String ?? "")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "user-id")
    aCoder.encode(self.username, forKey: "user-username")
    aCoder.encode(self.email, forKey: "user-email")
    aCoder.encode(self.image?.absoluteString, forKey: "user-image")
  }
}
