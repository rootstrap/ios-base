//
//  RegisterDelegate.swift
//  ios-base
//
//  Created by Lucas Miotti on 27/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol RegisterDelegate: UIFormFieldDelegate, AuthDelegate {

  func showNameError()
  func showEmailError()
  func showPasswordError()
  func showConfirmPasswordError()
  func showGenderError()
}
