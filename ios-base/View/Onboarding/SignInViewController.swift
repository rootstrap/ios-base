//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignInViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  var viewModel: SignInViewModelWithCredentials!

  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
    bindToViewModel()
    setLoginButton(enabled: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  private func bindToViewModel() {
    viewModel.hasValidCredentials.asObservable()
      .subscribe(onNext: { [weak self] isValid in
        self?.setLoginButton(enabled: isValid)
      }).disposed(by: disposeBag)

    viewModel.state.asObservable()
      .subscribe(onNext: { [weak self] state in
        self?.handleStateChange(state: state)
      }).disposed(by: disposeBag)

    emailField.rx.text.bind(to: viewModel.email)
      .disposed(by: disposeBag)
    passwordField.rx.text.bind(to: viewModel.password)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Actions
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    viewModel.login()
  }
  
  func setLoginButton(enabled: Bool) {
    logIn.alpha = enabled ? 1 : 0.5
    logIn.isEnabled = enabled
  }

  private func handleStateChange(state: ViewModelState) {
    switch state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Error", message: errorDescription)
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}
