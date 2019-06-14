//
//  SignUpViewModel.swift
//  ios-base
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignUpViewModelWithEmail {
  let disposeBag = DisposeBag()

  var state = BehaviorRelay(value: ViewModelState.idle)

  var email = BehaviorRelay<String?>(value: "")

  var password = BehaviorRelay<String?>(value: "")
  
  var passwordConfirmation = BehaviorRelay<String?>(value: "")

  var hasValidData = BehaviorRelay(value: false)

  init() {
    Observable
      .combineLatest(email, password, passwordConfirmation)
      .map { email, password, passwordConfirmation in
        guard
          let email = email,
          let password = password,
          let passwordConfirmation = passwordConfirmation
        else {
          return false
        }
        return email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation
      }
      .bind(to: hasValidData)
      .disposed(by: disposeBag)
  }
  
  func signup() {
    guard let email = email.value, let password = password.value else {
      return
    }
    state.accept(.loading)
    
    UserService.sharedInstance
      .signup(email, password: password, avatar64: UIImage.random())
      .subscribe(onNext: { user in
          self.state.accept(.idle)
          AnalyticsManager.shared.identifyUser(with: user.email)
          AnalyticsManager.shared.log(event: Event.registerSuccess(email: user.email))
          AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
        }, onError: { [weak self] error in
          if let apiError = error as? APIError {
            self?.state.accept(.error(apiError.firstError ?? "")) // show the first error
          } else {
            self?.state.accept(.error(error.localizedDescription))
          }
        }).disposed(by: disposeBag)
  }
}
