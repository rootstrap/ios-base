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
  
  // MARK: - Outlets
  
  @IBOutlet weak var facebookSign: UIButton!
  @IBOutlet weak var signIn: UIButton!
  @IBOutlet weak var signUp: UIButton!
  
  let activityIndicator = UIActivityIndicatorView()
  
  var viewModel: FirstViewModel!

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    [signIn, facebookSign].forEach({ $0?.setRoundBorders(22) })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Actions
  
  @IBAction func facebookLogin() {
    viewModel.facebookLogin()
  }

  @IBAction func signInTapped() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signIn, with: .push)
  }

  @IBAction func signUpTapped() {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signUp, with: .push)
  }
}
