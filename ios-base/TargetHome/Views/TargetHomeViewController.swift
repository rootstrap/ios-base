//
//  TargetHomeViewController.swift
//  ios-base
//
//  Created by Lucas Miotti on 27/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class TargetHomeViewController: UIViewController {
  
  private var viewModel: TargetHomeViewModel
  
  private var logOutButton = UIButton.primaryButton(
    color: UIColor.black,
    title: "LOG OUT",
    titleColor: .white,
    cornerRadius: 0,
    height: 37,
    font: UIFont.font(size: .heading5),
    action: #selector(tapOnButton)
  )
  
  init(viewModel: TargetHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubviews(subviews: [logOutButton])
    logOutButton.centerHorizontally(with: view)
    logOutButton.centerVertically(with: view)
  }
  
  @objc
  func tapOnButton(_ sender: UIButton) {
    viewModel.logOut()
    AppNavigator.shared.navigate(
      to: OnboardingRoutes.login,
      with: TransitionType.changeRoot
    )
  }
}
