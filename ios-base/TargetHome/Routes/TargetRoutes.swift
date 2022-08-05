//
//  TargetRoutes.swift
//  ios-base
//
//  Created by Lucas Miotti on 03/08/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

enum TargetRoutes: Route {
  case home
  case profile
  case chat

  var screen: UIViewController {
    switch self {
    case .home:
      return buildHomeViewController()
    case .profile:
      return buildProfileViewController()
    case .chat:
      return buildChatProfileViewController()
    }
  }

  private func buildHomeViewController() -> UIViewController {
    return TargetHomeViewController(viewModel: TargetHomeViewModel())
  }
  
  private func buildProfileViewController() -> UIViewController {
    return ProfileViewController(viewModel: ProfileViewModel())
  }
  
  private func buildChatProfileViewController() -> UIViewController {
    return ChatViewController(viewModel: ChatViewModel())
  }
}
