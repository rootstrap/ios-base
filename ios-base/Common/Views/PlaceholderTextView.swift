//
//  PlaceholderTextView.swift
//  talkative-iOS
//
//  Created by German Lopez on 6/6/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
  
  override var text: String! {
    didSet {
      // First text set, when placeholder is empty
      if text.isEmpty && text != placeholder && !self.isFirstResponder {
        text = placeholder
        return
      }
      textColor = text == placeholder ? placeholderColor : fontColor
    }
  }
  @IBInspectable var placeholder: String = "" {
    didSet {
      if text.isEmpty {
        text = placeholder
        textColor = placeholderColor
      }
    }
  }
  @IBInspectable var placeholderColor: UIColor? = .lightGray
  var fontColor: UIColor = .black
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    if let txtC = textColor {
      self.fontColor = txtC
    }
  }
    
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textColor = text == placeholder ? placeholderColor : fontColor
  }
  
  convenience init(
    frame: CGRect, placeholder: String = "", placeholderColor: UIColor = .lightGray
  ) {
    self.init(frame: frame)
    self.placeholderColor = placeholderColor
    self.placeholder = placeholder
    if let txtC = textColor {
      self.fontColor = txtC
    }
  }
  
  override func becomeFirstResponder() -> Bool {
    let isFirstResponder = super.becomeFirstResponder()
    if text == placeholder && textColor == placeholderColor {
      text = ""
    }
    textColor = fontColor
    return isFirstResponder
  }
  
  override func resignFirstResponder() -> Bool {
    if text.isEmpty {
      text = placeholder
      textColor = placeholderColor
    }
    return super.resignFirstResponder()
  }
}
