//
//  ChatViewController.swift
//  ios-base
//
//  Created by Lucas Miotti on 05/08/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
  
  private var viewModel: ChatViewModel
  
  private var navBar = UINavigationBar()
  
  private var mapNavButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: UIImage(named: "Pin"),
      style: UIBarButtonItem.Style.done,
      target: self,
      action: #selector(tapOnButton)
    )
    button.tintColor = UIColor.black
    return button
  }()
  
  private var profileNavButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: UIImage(named: "User"),
      style: UIBarButtonItem.Style.done,
      target: self,
      action: #selector(tapOnButton)
    )
    button.tintColor = UIColor.black
    return button
  }()
  
  init(viewModel: ChatViewModel) {
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
    view.addSubviews(subviews: [
      navBar
    ])
    setUpNavController()
  }
  
  private func setUpNavController() {
    navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
    let navItem = UINavigationItem(title: "Chat")
    navItem.rightBarButtonItem = mapNavButton
    navItem.leftBarButtonItem = profileNavButton
    navBar.setItems([navItem], animated: false)
    navBar.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor
    ).isActive = true
  }
  
  @objc
  func tapOnButton(_ sender: UIButton) {
    switch sender {
    case mapNavButton:
      navigationController?.pushViewController(
        TargetHomeViewController(viewModel: TargetHomeViewModel()),
        animated: true
      )
    case profileNavButton:
      navigationController?.pushViewController(
        ProfileViewController(viewModel: ProfileViewModel()),
        animated: true
      )
    default:
      return
    }
  }
}
