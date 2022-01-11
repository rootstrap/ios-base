//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: NetworkStatusDelegate {
  func didUpdateState(to state: HomeViewModelState)
}

enum HomeViewModelState {
  case loggedOut
  case loadedProfile
  case network(state: NetworkState)
}

class HomeViewModel {
  
  weak var delegate: HomeViewModelDelegate?
  
  var userEmail: String?
  
  private var state: HomeViewModelState = .network(state: .idle) {
    didSet {
      delegate?.didUpdateState(to: state)
    }
  }
  
  func loadUserProfile() {
    state = .network(state: .loading)
    
    UserServices.getMyProfile { [weak self] (result: Result<User, Error>) in
      switch result {
      case .success(let user):
        self?.userEmail = user.email
        self?.state = .loadedProfile
      case .failure(let error):
        self?.state = .network(state: .error(error.localizedDescription))
      }
    }
  }
  
  func logoutUser() {
    state = .network(state: .loading)
    
    AuthenticationServices.logout { [weak self] result in
      switch result {
      case .success:
        self?.didlogOutAccount()
      case .failure(let error):
        self?.state = .network(state: .error(error.localizedDescription))
      }
    }
  }
  
  func deleteAccount() {
    state = .network(state: .loading)
  
    AuthenticationServices.deleteAccount { [weak self] result in
      switch result {
      case .success:
        self?.didlogOutAccount()
      case .failure(let error):
        self?.state = .network(state: .error(error.localizedDescription))
      }
    }
  }
  
  private func didlogOutAccount() {
    state = .loggedOut
    AnalyticsManager.shared.reset()
  }
}
