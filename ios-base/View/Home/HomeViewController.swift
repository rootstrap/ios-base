//
//  HomeViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  // MARK: - Outlets
  
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var logOut: UIButton!
  
  var viewModel: HomeViewModel!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()

    bindToViewModel()
    logOut.setRoundBorders(22)
  }

  private func bindToViewModel() {
    viewModel.state.asObservable()
      .subscribe(onNext: { state in
        if state == .loading {
          UIApplication.showNetworkActivity()
        } else {
          UIApplication.hideNetworkActivity()
        }
      }).disposed(by: disposeBag)

    viewModel.userEmail.asObservable()
      .subscribe(onNext: { [weak self] email in
        guard let email = email else { return }
        self?.showMessage(title: "My Profile", message: "email: \(email)")
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Actions
  
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    viewModel.loadUserProfile()
  }

  @IBAction func tapOnLogOutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
}
