//
//  ProfileViewController.swift
//  ios-base
//
//  Created by Lucas Miotti on 03/08/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
  
  private var viewModel: ProfileViewModel
  
  private var navBar = UINavigationBar()
  
  private var backNavButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: UIImage(named: "Right arrow"),
      style: UIBarButtonItem.Style.done,
      target: self,
      action: #selector(tapOnButton)
    )
    button.tintColor = UIColor.black
    return button
  }()
  
  private var logOutButton = UIButton.primaryButton(
    color: UIColor.black,
    title: "LOG OUT",
    titleColor: .white,
    cornerRadius: 0,
    height: 37,
    font: UIFont.font(size: .heading5),
    action: #selector(tapOnButton)
  )
  
  init(viewModel: ProfileViewModel) {
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
    setUpNavController()
    view.addSubviews(subviews: [navBar])
  }
  
  private func setUpNavController() {
    navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
    let navItem = UINavigationItem(title: "Profile")
    navItem.rightBarButtonItem = backNavButton
    navBar.setItems([navItem], animated: false)
  }
  
  @objc
  func tapOnButton(_ sender: UIButton) {
    switch sender {
    case logOutButton:
      viewModel.logOut()
      AppNavigator.shared.navigate(
        to: OnboardingRoutes.login,
        with: TransitionType.changeRoot
      )
    case backNavButton:
      navigationController?.popViewController(animated: true)
    default:
      return
    }
  }
}
