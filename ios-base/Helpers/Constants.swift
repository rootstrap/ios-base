//
//  Constants.swift
//  ios-base
//
//  Created by German Lopez on 3/29/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

//Add global constants here

struct App {
  static let domain = Bundle.main.bundleIdentifier ?? ""
  
  static func error(
    domain: ErrorDomain = .generic, code: Int? = nil,
    localizedDescription: String = ""
  ) -> NSError {
    return NSError(domain: App.domain + "." + domain.rawValue,
                   code: code ?? 0,
                   userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }
}

enum ErrorDomain: String {
  case generic = "GenericError"
  case parsing = "ParsingError"
}

struct UI {
  enum Defaults {
    static let margin: CGFloat = 32
  }
  
  enum ViewController {
    static let topMargin: CGFloat = 72
  }
  
  enum Button {
    static let cornerRadious: CGFloat = 22.0
    static let height: CGFloat = 45.0
    static let width: CGFloat = 200.0
    static let spacing: CGFloat = 20.0
  }
  
  enum TextField {
  }
  
  enum Label {
  }
}
