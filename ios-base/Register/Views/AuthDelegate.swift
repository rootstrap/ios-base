//
//  AuthDelegate.swift
//  ios-base
//
//  Created by Lucas Miotti on 18/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol AuthDelegate {

  func onAuthSuccess()
  func onAuthError(errorCode: String)
}
