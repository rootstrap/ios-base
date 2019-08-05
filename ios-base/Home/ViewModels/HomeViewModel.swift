//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
  func didUpdateState()
}

class HomeViewModel {
  
  weak var delegate: HomeViewModelDelegate?
  
  var userEmail: String?
  
  var state: ViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  func loadUserProfile() {
    state = .loading
    UserService.sharedInstance.getMyProfile({ [weak self] user in
      self?.userEmail = user.email
      self?.state = .idle
    }, failure: { [weak self] error in
      self?.state = .error(error.localizedDescription)
    })
  }
  
  func logoutUser() {
    state = .loading
    UserService.sharedInstance.logout({ [weak self] in
      self?.state = .idle
      AppNavigator.shared.navigate(to: OnboardingRoutes.firstScreen, with: .changeRoot)
      AnalyticsManager.shared.reset()
    }, failure: { [weak self] error in
      self?.state = .error(error.localizedDescription)
    })
  }
}
