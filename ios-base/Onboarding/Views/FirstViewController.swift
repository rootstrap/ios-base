//
//  ViewController.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,
  AuthViewModelStateDelegate,
  ActivityIndicatorPresenter {
  
  // MARK: - Views
  
  private lazy var titleLabel = UILabel.titleLabel(
    text: "firstscreen_title".localized
  )
  
  private lazy var facebookSignButton = UIButton.primaryButton(
    color: .facebookButton,
    title: "firstscreen_facebook_button_title".localized,
    target: self,
    action: #selector(facebookLogin)
  )
  
  private lazy var signInButton = UIButton.primaryButton(
    title: "firstscreen_login_button_title".localized,
    target: self,
    action: #selector(signInTapped)
  )
  
  private lazy var signUpButton = UIButton.primaryButton(
    color: .clear,
    title: "firstscreen_registre_button_title".localized,
    titleColor: .mainTitle,
    target: self,
    action: #selector(signUpTapped)
  )
  
  let activityIndicator = UIActivityIndicatorView()
  
  private let viewModel: FirstViewModel
  
  init(viewModel: FirstViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    
    configureViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  // MARK: View Configuration
  
  private func configureViews() {
    applyDefaultUIConfigs()
    view.addSubviews(
      subviews: [titleLabel, signInButton, facebookSignButton, signUpButton]
    )
    activateConstraints()
    setupAccessibility()
  }

  private func setupAccessibility() {
    signUpButton.accessibilityIdentifier = "GoToSignUpButton"
    signInButton.accessibilityIdentifier = "GoToSignInButton"
  }
  
  private func activateConstraints() {
    facebookSignButton.centerHorizontally(with: view)
    signInButton.centerHorizontally(with: view)
    titleLabel.attachHorizontally(to: view)
    signUpButton.attachHorizontally(to: view)
    facebookSignButton.attachHorizontally(to: view)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: UI.ViewController.topMargin
      ),
      signInButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UI.Button.width),
      signUpButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -UI.Defaults.margin
      ),
      facebookSignButton.bottomAnchor.constraint(
        equalTo: signUpButton.topAnchor,
        constant: -UI.Button.spacing
      ),
      signInButton.bottomAnchor.constraint(
        equalTo: facebookSignButton.topAnchor,
        constant: -UI.Button.spacing
      )
    ])
    
  }
  
  // MARK: - Actions
  
  @objc
  func facebookLogin() {
    viewModel.facebookLogin()
  }
  
  @objc
  func signInTapped() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signIn, with: .push)
  }
  
  @objc
  func signUpTapped() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signUp, with: .push)
  }
}
