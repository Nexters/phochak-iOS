//
//  SceneFactory.swift
//  Feature
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import UIKit

public enum Scene {
  case tab
  case login
  case search
  case postRolling(videoPosts: [VideoPost], currentIndex: Int)

  var title: String {
    switch self {
    case .tab: return ""
    case .login: return "Login"
    case .search: return ""
    case .postRolling: return ""
    }
  }
}

public protocol SceneFactoryType {
  func create(scene: Scene) -> UIViewController
}

final class SceneFactory: SceneFactoryType {

  // MARK: Properties
  private let injector: DependencyResolvable

  struct Dependency {
    let injetor: DependencyResolvable
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.injector = dependency.injetor
  }

  // MARK: Methods
  public func create(scene: Scene) -> UIViewController {
    switch scene {
    case .login:
      return UIViewController()

    case .search:
      let searchViewController: UIViewController = .init(nibName: nil, bundle: nil)
      return searchViewController

    case let .postRolling(videoPosts, currentIndex):
      let coordinator = injector.resolve(AppCoordinatorType.self)
      let videoPostUseCase = injector.resolve(VideoPostUseCaseType.self)
      let postRollingViewController: PostRollingViewController = .init(
        reactor: .init(
          dependency: .init(
            coordinator: coordinator,
            videoPosts: videoPosts,
            currentIndex: currentIndex,
            useCase: videoPostUseCase
          )
        )
      )
      postRollingViewController.hidesBottomBarWhenPushed = true
      return postRollingViewController

    case .tab:
      let tabBarController: PhoChakTabBarController = .init(nibName: nil, bundle: nil)

      let coordinator = injector.resolve(AppCoordinatorType.self)
      let videoPostUseCase = injector.resolve(VideoPostUseCaseType.self)
      let homeViewController: HomeViewController = .init(
        reactor: .init(
          dependency: .init(
            coordinaotr: coordinator,
            useCase: videoPostUseCase
          )
        )
      )
      homeViewController.tabBarItem = .init(
        title: nil,
        image: .createImage(.tab_home),
        selectedImage: .createImage(.tab_home_selected)
      )

      let videoUploadViewController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadViewController.tabBarItem = .init(
        title: nil,
        image: nil,
        selectedImage: nil
      )

      let profileViewController: ProfileViewController = .init(nibName: nil, bundle: nil)
      profileViewController.tabBarItem = .init(
        title: nil,
        image: .createImage(.tab_profile),
        selectedImage: .createImage(.tab_profile_selected)
      )

      tabBarController.setViewControllers(
        [
          UINavigationController(rootViewController: homeViewController),
          UINavigationController(rootViewController: videoUploadViewController),
          UINavigationController(rootViewController: profileViewController)
        ],
        animated: false
      )

      return tabBarController
    }
  }
}
