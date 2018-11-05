//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

enum HomeViewModelState: Equatable {
  case loading
  case error(String)
  case idle
  case loggedOut
}

protocol HomeViewModelDelegate: class {
  func didUpdateState()
}

class HomeViewModel {
  
  weak var delegate: HomeViewModelDelegate?
  
  var userEmail: String?
  
  var state: HomeViewModelState = .idle {
    didSet {
        delegate?.didUpdateState()
    }
  }
  
  func loadUserProfile() {
    state = .loading
    UserAPI.getMyProfile({ [weak self] user in
      self?.userEmail = user.email
      self?.state = .idle
    }, failure: { [weak self] error in
      self?.state = .error(error.localizedDescription)
    })
  }
  
  func logoutUser() {
    state = .loading
    UserAPI.logout({ [weak self] in
      self?.state = .loggedOut
    }, failure: { [weak self] error in
      self?.state = .error(error.localizedDescription)
    })
  }
}
