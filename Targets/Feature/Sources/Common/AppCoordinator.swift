////
////  AppCoordinator.swift
////  PhoChak
////
////  Created by Ian on 2023/01/16.
////  Copyright © 2023 PhoChak. All rights reserved.
////

import Core
import UIKit

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

public protocol AppCoordinatorType {
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
  private var currentViewController: UIViewController?
  private let sceneFactory: SceneFactory

  public struct Dependency {
    let injector: DependencyResolvable

    public init(injector: DependencyResolvable) {
      self.injector = injector
    }
  }

  // MARK: Initializer
  public init(dependency: Dependency) {
    self.sceneFactory = .init(dependency: .init(injetor: dependency.injector))
  }

  public func start(from root: Scene) {
    let rootViewController = sceneFactory.create(scene: root)
    self.currentViewController = rootViewController

    UIApplication.keyWindow?.rootViewController = rootViewController
  }

  public func transition(to scene: Scene, style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
    guard let currentViewController = currentViewController else {
      return
    }

    let viewController = sceneFactory.create(scene: scene)

    switch style {
    case .push:
      currentViewController.navigationController?
        .pushViewController(viewController, animated: true)

    case .modal:
      currentViewController.present(viewController, animated: animated, completion: completion)
    }
  }

  public func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
    guard let currentViewController = currentViewController else {
      return
    }

    switch style {
    case .root:
      self.currentViewController?
        .navigationController?
        .popToRootViewController(animated: animated)
      completion?()

    case .pop:
      self.currentViewController?.navigationController?.popViewController(animated: true)

    case .dismiss:
      if let presentingViewController = currentViewController.presentingViewController {
        currentViewController.dismiss(animated: animated, completion: {
          self.currentViewController = presentingViewController
          completion?()
        })
      } else {
        currentViewController.dismiss(animated: animated, completion: completion)
      }

    case .target(let scene):
      guard let viewControllers = currentViewController.navigationController?.viewControllers else {
        return
      }

      guard let target = viewControllers.first(where: {
        switch scene {
        case .tab:
          return $0 is PhoChakTabBarController
        case .login:
          return false
        case .home:
          return $0 is HomeViewController
        case .videoUpload:
          return $0 is VideoUploadViewController
        case .profile:
          return $0 is ProfileViewController
        }
      }) else { return }

      currentViewController.navigationController?
        .popToViewController(target, animated: animated)
    }
  }
}
