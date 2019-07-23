//
//  ConfigurationManager.swift
//  ios-base
//
//  Created by Camila Moscatelli on 6/2/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject {

  class func getValue(for key: String, on propertyList: String = "ThirdPartyKeys") -> String? {
    if let path = Bundle.main.path(forResource: propertyList, ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
      if let configDict = dict[key] as? [String: AnyObject] {
        return configDict[Bundle.main.object(forInfoDictionaryKey: "ConfigurationName") as? String ?? ""] as? String
      } else if let value = dict[key] as? String {
        return value
      }
    }
    
    print("ThirdPartyKeys.plist NOT FOUND - Please check your project configuration in: \n https://github.com/rootstrap/ios-base")
    return nil
  }
}
