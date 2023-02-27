//
//  AppCoordinator.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import DesignKit
import UIKit

import RxSwift

public enum TransitionStyle {
  case push
  case modal
}

public enum CloseStyle {
  case root
  case target(Scene)
  case pop
  case dismiss
}

public protocol AppCoordinatorType: AnyObject {
  func start(from root: Scene)
  func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)?)
  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?)
}

extension AppCoordinatorType {
  func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
    self.transition(to: scene, style: style, animated: animated, completion: completion)
  }

  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
    self.close(style: style, animated: animated, completion: completion)
  }
}

public final class AppCoordinator: AppCoordinatorType {

  // MARK: Properties
  private var currentNavController: UINavigationController?
  private let sceneFactory: SceneFactory
  private lazy var disposeBag: DisposeBag = .init()

  public struct Dependency {
    let injector: DependencyResolvable

    public init(injector: DependencyResolvable) {
      self.injector = injector
    }
  }

  // MARK: Initializer
  public init(dependency: Dependency) {
    self.sceneFactory = .init(dependency: .init(injector: dependency.injector))
    addTokenObserver()
  }

  public func start(from root: Scene) {
    let rootViewController = sceneFactory.create(scene: root)
    self.currentNavController = rootViewController.navigationController

    UIApplication.keyWindow?.rootViewController = rootViewController
  }

  public func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
    let navController: UINavigationController

    if let currentNavController = currentNavController {
      navController = currentNavController
    } else {
      navController = (UIApplication.keyWindow?.rootViewController as? PhoChakTabBarController)?
        .selectedViewController as! UINavigationController
      self.currentNavController = navController
    }

    let createdViewController = sceneFactory.create(scene: scene)

    switch style {
    case .push:
      navController.pushViewController(createdViewController, animated: animated)

    case .modal:
      navController.present(createdViewController, animated: animated, completion: completion)
    }
  }

  public func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
    let navController: UINavigationController

    if let currentNavController = currentNavController {
      navController = currentNavController
    } else {
      navController = (UIApplication.keyWindow?.rootViewController as? PhoChakTabBarController)?
        .selectedViewController as! UINavigationController
      self.currentNavController = navController
    }

    switch style {
    case .root:
      self.currentNavController?
        .popToRootViewController(animated: animated)
      completion?()

    case .pop:
      self.currentNavController?.navigationController?.popViewController(animated: true)

    case .dismiss:
      self.currentNavController?.dismiss(animated: animated, completion: completion)

    case .target(let scene):
      guard let viewControllers = currentNavController?.viewControllers else {
        return
      }

      guard let target = viewControllers.first(where: {
        switch scene {
        case .tab:
          return $0 is PhoChakTabBarController
        case .signIn:
          return $0 is SignInViewController
        case .splash:
          return $0 is SplashViewController
        case .search:
          return true
        case .postRolling:
          return $0 is PostRollingViewController
        case .uploadVideoPost:
          return $0 is UploadVideoPostViewController
        }
      }) else { return }

      currentNavController?.popToViewController(target, animated: animated)
    }
  }
}

// MARK: - Private
private extension AppCoordinator {

  // MARK: Methods
  func addTokenObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(exitToSignIn),
      name: NSNotification.Name("reSignIn"),
      object: nil
    )
  }

  @objc func exitToSignIn() {
    let alertViewController: PhoChakAlertViewController = .init(alertType: .tokenExpired)

    alertViewController.acceptButtonAction
      .emit(with: self, onNext: { owner, _ in
        owner.start(from: .signIn)
      })
      .disposed(by: disposeBag)

    UIApplication.keyWindow?.rootViewController?.present(alertViewController, animated: true)
  }
}
