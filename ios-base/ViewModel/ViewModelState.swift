//
//  ViewModelState.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

enum ViewModelState: Equatable {
  case loading
  case error(String)
  case idle
}
