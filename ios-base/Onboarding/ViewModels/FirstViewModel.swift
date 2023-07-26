//
//  FirstViewModel.swift
//  ios-base
//
//  Created by German Stabile on 11/2/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation

class FirstViewModel {
  
  var state: AuthViewModelState = .network(state: .idle) {
    didSet {
      delegate?.didUpdateState(to: state)
    }
  }
  
  weak var delegate: AuthViewModelStateDelegate?
}
