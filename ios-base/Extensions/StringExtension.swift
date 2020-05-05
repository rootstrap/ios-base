//
//  StringExtension.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import Foundation

extension String {
  var isAlphanumericWithNoSpaces: Bool {
    let alphaNumSet = CharacterSet(
      charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    )
    return rangeOfCharacter(from: alphaNumSet.inverted) == nil
  }
  
  var hasPunctuationCharacters: Bool {
    return rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
  }
  
  var hasNumbers: Bool {
    return rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
  }
  
  var localized: String {
    return self.localize()
  }
    
  func localize(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  var validFilename: String {
    guard !isEmpty else { return "emptyFilename" }
    return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "emptyFilename"
  }
  
  //Regex fulfill RFC 5322 Internet Message format
  func isEmailFormatted() -> Bool {
    // swiftlint:disable line_length
    let emailRegex = "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?"
    // swiftlint:enable line_length
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: self)
  }
}
