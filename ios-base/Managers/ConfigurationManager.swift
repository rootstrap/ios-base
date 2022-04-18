//
//  ConfigurationManager.swift
//  ios-base
//
//  Created by Camila Moscatelli on 6/2/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import Foundation

class ConfigurationManager: NSObject {

  private static let environmentKeyName = "ConfigurationName"

  class func getValue(for key: String, on propertyList: String) -> String? {
    if
      let path = Bundle.main.path(forResource: propertyList, ofType: "plist"),
      let plistData = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
    {
      if
        let configuration = plistData[key] as? [String: AnyObject],
        let env = Bundle.main.object(forInfoDictionaryKey: environmentKeyName) as? String
      {
        return configuration[env] as? String
      } else if let value = plistData[key] as? String {
        return value
      }
    }
    
    print("""
      \(propertyList).plist NOT FOUND -
      Please check your project configuration in: \n https://github.com/rootstrap/ios-base
    """)
    return nil
  }
}
