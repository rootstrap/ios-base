//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignInViewModelWithCredentials {
  let disposeBag = DisposeBag()
  
  var state = BehaviorRelay(value: ViewModelState.idle)
  
  var email = BehaviorRelay<String?>(value: "")
  
  var password = BehaviorRelay<String?>(value: "")
  
  var hasValidCredentials = BehaviorRelay(value: false)

  init() {
    Observable.combineLatest(email, password)
      .map { email, password in
        return (email ?? "").isEmailFormatted() && !(password ?? "").isEmpty
      }
      .bind(to: hasValidCredentials)
      .disposed(by: disposeBag)
  }
  
  func login() {
    guard let email = email.value, let password = password.value else { return }
    state.accept(.loading)
    UserService.sharedInstance.login(email, password: password)
      .subscribe(onNext: { [weak self] user in
        guard let self = self else { return }
        self.state.accept(.idle)
        AnalyticsManager.shared.identifyUser(with: user.email)
        AnalyticsManager.shared.log(event: Event.login)
        AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
      }, onError: { [weak self] error in
        self?.state.accept(.error(error.localizedDescription))
      }).disposed(by: disposeBag)
  }
}
