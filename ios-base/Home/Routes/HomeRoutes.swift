//
//  HomeRoutes.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

enum HomeRoutes: Route {
  case home

  var screen: UIViewController {
    switch self {
    case .home:
      let home = HomeViewController(viewModel: HomeViewModel())
      return home
    }
  }
}
