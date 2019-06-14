//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  
  var viewModel: SignUpViewModelWithEmail!

  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUp.setRoundBorders(22)
    bindToViewModel()
    setSignUpButton(enabled: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  private func bindToViewModel() {
    viewModel.hasValidData.asObservable()
      .subscribe(onNext: { [weak self] isValid in
        self?.setSignUpButton(enabled: isValid)
      }).disposed(by: disposeBag)
    
    viewModel.state.asObservable()
      .subscribe(onNext: { [weak self] state in
        self?.handleStateChange(state: state)
      }).disposed(by: disposeBag)

    emailField.rx.text.bind(to: viewModel.email).disposed(by: disposeBag)
    passwordField.rx.text.bind(to: viewModel.password).disposed(by: disposeBag)
    passwordConfirmationField.rx.text.bind(to: viewModel.passwordConfirmation).disposed(by: disposeBag)
  }

  private func setSignUpButton(enabled: Bool) {
    signUp.alpha = enabled ? 1 : 0.5
    signUp.isEnabled = enabled
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
  
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    viewModel.signup()
  }
}
