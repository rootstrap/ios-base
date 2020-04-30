//
//  Navigator.swift
//  ios-base
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 The base navigator class implements the navigator protocol
 exposing basic behaviour extensible via inheritance.
 For example, you should subclass if you want to add
 some logic to the initial route by checking something
 stored in your keychain.
 */
open class BaseNavigator: Navigator {
  open var rootViewController: UINavigationController?
  open var currentViewController: UIViewController? {
    return
      rootViewController?.visibleViewController ?? rootViewController?.topViewController
  }

  public required init(with route: Route) {
    rootViewController = route.screen.embedInNavigationController()
  }
}

/**
 The Navigator is the base of this framework, it handles all
 your application navigation stack.
 It keeps track of your root NavigationController and the
 ViewController that is currently displayed. This way it can
 handle any kind of navigation action that you might want to dispatch.
 */
public protocol Navigator: class {
  /// The root navigation controller of your stack.
  var rootViewController: UINavigationController? { get set }

  /// The currently visible ViewController
  var currentViewController: UIViewController? { get }

  /// Convencience init to set your application starting screen.
  init(with route: Route)

  /**
   Navigate from your current screen to a new route.
   - Parameters:
   - route: The destination route of your navigation action.
   - transition: The transition type that you want to use.
   - animated: Animate the transition or not.
   - completion: Completion handler.
   */
  func navigate(
    to route: Route, with transition: TransitionType,
    animated: Bool, completion: (() -> Void)?
  )

  /**
   Navigate from your current screen to a new entire navigator.
   Can only push a router as a modal.
   Afterwards, other controllers can be pushed inside the presented Navigator.
   - Parameters:
   - Navigator: The destination navigator that you want to navigate to
   - animated: Animate the transition or not.
   - completion: Completion handler.
   */
  func navigate(to router: Navigator, animated: Bool, completion: (() -> Void)?)

  /**
   Handles backwards navigation through the stack.
   */
  func pop(animated: Bool)

  /**
   Handles backwards navigation through the stack.
   - Parameters:
   - route: The index of the route of your navigation action.
   - animated: Animate the transition or not.
   */
  func popTo(index: Int, animated: Bool)

  /**
   Handles backwards navigation through the stack.
   - Parameters:
   - route: The destination route of your navigation action.
   - animated: Animate the transition or not.
   */
  func popTo(route: Route, animated: Bool)

  /**
   Dismiss your current ViewController.
   - Parameters:
   - animated: Animate the transition or not.
   - completion: Completion handler.
   */
  func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension Navigator {
  func navigate(
    to route: Route, with transition: TransitionType,
    animated: Bool = true, completion: (() -> Void)? = nil
  ) {
    let viewController = route.screen
    switch transition {
    case .modal:
      route.transitionConfigurator?(currentViewController, viewController)
      currentViewController?.present(
        viewController, animated: animated, completion: completion
      )
    case .push:
      route.transitionConfigurator?(currentViewController, viewController)
      rootViewController?.pushViewController(viewController, animated: animated)
    case .reset:
      route.transitionConfigurator?(nil, viewController)
      rootViewController?.setViewControllers([viewController], animated: animated)
    case .changeRoot(let transitionType, let transitionSubtype):
      let navigationController = viewController.embedInNavigationController()
      animateRootReplacementTransition(
        to: navigationController,
        withTransitionType: transitionType,
        andTransitionSubtype: transitionSubtype
      )
      rootViewController = navigationController
    }
  }

  func navigate(to router: Navigator, animated: Bool, completion: (() -> Void)?) {
    guard let viewController = router.rootViewController else {
      assert(false, "Navigator does not have a root view controller")
      return
    }

    currentViewController?.present(
      viewController, animated: animated, completion: completion
    )
  }

  func pop(animated: Bool = true) {
    rootViewController?.popViewController(animated: animated)
  }

  func popToRoot(animated: Bool = true) {
    rootViewController?.popToRootViewController(animated: animated)
  }

  func popTo(index: Int, animated: Bool = true) {
    guard
      let viewControllers = rootViewController?.viewControllers,
      viewControllers.count > index
    else { return }
    let viewController = viewControllers[index]
    rootViewController?.popToViewController(viewController, animated: animated)
  }

  func popTo(route: Route, animated: Bool = true) {
    guard
      let viewControllers = rootViewController?.viewControllers,
      let viewController = viewControllers.first(where: {
        type(of: $0) == type(of: route.screen)
      })
    else { return }
    rootViewController?.popToViewController(viewController, animated: true)
  }

  func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
    currentViewController?.dismiss(animated: animated, completion: completion)
  }
  
  private func animateRootReplacementTransition(
    to viewController: UIViewController,
    withTransitionType type: CATransitionType,
    andTransitionSubtype subtype: CATransitionSubtype
  ) {
    let window = UIApplication.shared.keyWindow
    let transition = CATransition()
    transition.duration = 0.3
    transition.timingFunction = CAMediaTimingFunction(
      name: CAMediaTimingFunctionName.easeOut
    )
    transition.type = type
    transition.subtype = subtype
    window?.layer.add(transition, forKey: kCATransition)
  
    window?.rootViewController = viewController
  }
}

/**
 Protocol used to define a Route. The route contains
 all the information necessary to instantiate it's screen.
 For example, you could have a LoginRoute, that knows how
 to instantiate it's viewModel, and also forward any
 information that it's passed to the Route.
 */
public protocol Route {
  typealias TransitionConfigurator = (
    _ sourceVc: UIViewController?, _ destinationVc: UIViewController
  ) -> Void

  /// The screen that should be returned for that Route.
  var screen: UIViewController { get }

  /**
   Configuration callback executed just before pushing/presenting modally.
   Use this to set up any custom transition delegate, presentationStyle, etc.
   - Parameters:
   - sourceVc: The currently visible viewController, if any.
   - destinationVc: The (fully intialized) viewController to present.
   */
  var transitionConfigurator: TransitionConfigurator? { get }
}

public extension Route {
  var transitionConfigurator: TransitionConfigurator? {
    return nil
  }
}

/// Available Transition types for navigation actions.
public enum TransitionType {

  /// Presents the screen modally on top of the current ViewController
  case modal

  /// Pushes the next screen to the rootViewController navigation Stack.
  case push

  /// Resets the rootViewController navitationStack and set's the Route's screen
  /// as the initial view controller of the stack.
  case reset

  /// Replaces the key window's Root view controller with the Route's screen.
  case changeRoot(
    transitionType: CATransitionType,
    transitionSubtype: CATransitionSubtype
  )
  
  /// Allows to use the changeRoot transition type with default parameters
  static let changeRoot: TransitionType = .changeRoot(
    transitionType: .push,
    transitionSubtype: .fromTop
  )
}

public extension UIViewController {
  func embedInNavigationController() -> UINavigationController {
    if let navigation = self as? UINavigationController {
      return navigation
    }
    let navigationController = UINavigationController(rootViewController: self)
    navigationController.isNavigationBarHidden = true
    return navigationController
  }
}
