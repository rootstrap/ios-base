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
  
//  @IBOutlet weak var welcomeLabel: UILabel!
//  @IBOutlet weak var logOut: UIButton!
//  @IBOutlet weak var deleteAccountButton: UIButton!
  
  private lazy var welcomeLabel = UILabel.titleLabel(
    text: "You are signed in/up".localized
  )
  
  private lazy var logOutButton = UIButton.primaryButton(
    color: .black,
    title: "LOG OUT".localized,
    target: self,
    action: #selector(tapOnLogOutButton)
  )
  
  private lazy var deleteAccountButton = UIButton.primaryButton(
    color: .deleteButton,
    title: "DELETE ACCOUNT".localized,
    target: self,
    action: #selector(tapOnDeleteAccount)
  )
  
  private lazy var getProfileButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Get my profile", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(
      self,
      action: #selector(tapOnGetMyProfile),
      for: .touchUpInside
    )
    
    return button
  }()
    
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: HomeViewModel!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    configureViews()
  }
  
  // MARK: - Actions
  
  @objc
  func tapOnGetMyProfile(_ sender: Any) {
    viewModel.loadUserProfile()
  }

  @objc
  func tapOnLogOutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
  
  @objc
  func tapOnDeleteAccount(_ sender: Any) {
    viewModel.deleteAccount()
  }
}

private extension HomeViewController {
  
  private func configureViews() {
    applyDefaultUIConfigs()
    view.addSubviews(
      subviews: [welcomeLabel, logOutButton, deleteAccountButton, getProfileButton]
    )
    activateConstraints()
  }
  
  private func activateConstraints() {
    welcomeLabel.centerHorizontally(with: view)
    getProfileButton.center(view)
    logOutButton.attachHorizontally(to: view)
    deleteAccountButton.attachHorizontally(to: view)
    
    NSLayoutConstraint.activate([
      welcomeLabel.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: UI.ViewController.topMargin
      ),
      deleteAccountButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -UI.Defaults.margin
      ),
      logOutButton.bottomAnchor.constraint(
        equalTo: deleteAccountButton.topAnchor,
        constant: -UI.Button.spacing
      )
    ])
    
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
