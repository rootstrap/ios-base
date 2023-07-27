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
  
  private let userServices: UserServices
  private let authServices: AuthenticationServices
  
  init(
    userServices: UserServices = UserServices(),
    authServices: AuthenticationServices = AuthenticationServices()
  ) {
    self.userServices = userServices
    self.authServices = authServices
  }
  
  func loadUserProfile() async {
    state = .network(state: .loading)
    
    let result = await userServices.getMyProfile()
    switch result {
    case .success(let user):
      self.userEmail = user.data.email
      self.state = .loadedProfile
    case .failure(let error):
      self.state = .network(state: .error(error.localizedDescription))
    }
  }
  
  func logoutUser() async {
    state = .network(state: .loading)
    
    let result = await authServices.logout()
    switch result {
    case .success:
      self.didlogOutAccount()
    case .failure(let error):
      self.state = .network(state: .error(error.localizedDescription))
    }
  }
  
  func deleteAccount() async {
    state = .network(state: .loading)
    
    let result = await authServices.deleteAccount()
    switch result {
    case .success:
      self.didlogOutAccount()
    case .failure(let error):
      self.state = .network(state: .error(error.localizedDescription))
    }
  }
  
  private func didlogOutAccount() {
    state = .loggedOut
    AnalyticsManager.shared.reset()
  }
}
