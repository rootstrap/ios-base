//
//  HomeViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var logOut: UIButton!
  @IBOutlet weak var deleteAccountButton: UIButton!
  
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
  func didUpdateState() {
    switch viewModel.state {
    case .idle:
      UIApplication.hideNetworkActivity()
      showMessage(title: "My Profile", message: "email: \(viewModel.userEmail ?? "")")
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      print(errorDescription)
    }
  }
}
