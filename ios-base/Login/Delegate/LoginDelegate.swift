//
//  LoginDelegate.swift
//  ios-base
//
//  Created by Lucas Miotti on 21/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol LoginDelegate: UIFormFieldDelegate, AuthDelegate {
  
  func showEmailError()
  func showPasswordError()
}
