//
//  HomeViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
  var userEmail = BehaviorRelay<String?>(value: nil)
  
  var state = BehaviorRelay<ViewModelState>(value: .idle)

  let disposeBag = DisposeBag()
  
  func loadUserProfile() {
    state.accept(.loading)
    UserService.sharedInstance.getMyProfile()
      .subscribe(onNext: { [weak self] user in
        self?.userEmail.accept(user.email)
        self?.state.accept(.idle)
      }, onError: { [weak self] error in
        self?.state.accept(.error(error.localizedDescription))
      }).disposed(by: disposeBag)
  }
  
  func logoutUser() {
    state.accept(.loading)
    UserService.sharedInstance.logout()
      .subscribe(onNext: { [weak self] in
          self?.state.accept(.idle)
          AppNavigator.shared.navigate(to: OnboardingRoutes.firstScreen, with: .changeRoot)
        }, onError: { [weak self] error in
          self?.state.accept(.error(error.localizedDescription))
      }).disposed(by: disposeBag)
  }
}
