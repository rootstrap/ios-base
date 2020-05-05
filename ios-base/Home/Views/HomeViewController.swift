//
//  HomeViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ActivityIndicatorPresenter {
  
  // MARK: - Outlets
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var logOut: UIButton!
  @IBOutlet weak var deleteAccountButton: UIButton!
    
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: HomeViewModel!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    logOut.setRoundBorders(22)
    deleteAccountButton.setRoundBorders(22)
  }
  
  // MARK: - Actions
  
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    viewModel.loadUserProfile()
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
  
  @IBAction func tapOnDeleteAccount(_ sender: Any) {
    viewModel.deleteAccount()
  }
}

extension HomeViewController: HomeViewModelDelegate {
  func didUpdateState(to state: HomeViewModelState) {
    switch state {
    case .network(let networkStatus):
      networkStatusChanged(to: networkStatus)
    case .loadedProfile:
      showActivityIndicator(false)
      showMessage(title: "My Profile", message: "email: \(viewModel.userEmail ?? "")")
    case .loggedOut:
      showActivityIndicator(false)
      AppNavigator.shared.navigate(
        to: OnboardingRoutes.firstScreen,
        with: .changeRoot
      )
    }
  }
}
