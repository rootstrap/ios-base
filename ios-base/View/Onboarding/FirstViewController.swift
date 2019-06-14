//
//  ViewController.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FirstViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var facebookSign: UIButton!
  @IBOutlet weak var signIn: UIButton!
  @IBOutlet weak var signUp: UIButton!
  
  var viewModel: FirstViewModel!

  let disposeBag = DisposeBag()

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    [signIn, facebookSign].forEach({ $0?.setRoundBorders(22) })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
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
  }

  // MARK: - Actions
  
  @IBAction func facebookLogin() {
    viewModel.facebookLogin()
  }

  @IBAction func signInTapped() {
    viewModel.signIn()
  }

  @IBAction func signUpTapped() {
    viewModel.signUp()
  }
}
