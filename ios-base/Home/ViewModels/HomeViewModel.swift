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
    
    UserServices.getMyProfile(
      success: { [weak self] user in
        self?.userEmail = user.email
        self?.state = .loadedProfile
      },
      failure: { [weak self] error in
        self?.state = .network(state: .error(error.localizedDescription))
      }
    )
  }
  
  func logoutUser() {
    state = .network(state: .loading)
    
    AuthenticationServices.logout(
      success: { [weak self] in
        self?.didlogOutAccount()
      },
      failure: { [weak self] error in
        self?.state = .network(state: .error(error.localizedDescription))
      }
    )
  }
  
  func deleteAccount() {
    state = .network(state: .loading)
  
    AuthenticationServices.deleteAccount(
      success: { [weak self] in
        self?.didlogOutAccount()
      },
      failure: { [weak self] error in
        self?.state = .network(state: .error(error.localizedDescription))
      }
    )
  }
  
  private func didlogOutAccount() {
    state = .loggedOut
    AnalyticsManager.shared.reset()
  }
}
