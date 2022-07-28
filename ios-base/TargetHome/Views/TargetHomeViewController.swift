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
  
  init(viewModel: TargetHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
