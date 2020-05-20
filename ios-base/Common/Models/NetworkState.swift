//
//  NetworkState.swift
//  ios-base
//
//  Created by German on 5/20/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

enum NetworkState {
  case idle, loading, error(_ error: String)
}
