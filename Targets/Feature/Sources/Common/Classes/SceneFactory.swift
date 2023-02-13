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
  case signIn
  case search
  case postRolling(videoPosts: [VideoPost], currentIndex: Int)
}

public protocol SceneFactoryType {
  func create(scene: Scene) -> UIViewController
}

final class SceneFactory: SceneFactoryType {

  // MARK: Properties
  private let injector: DependencyResolvable
  private var homeViewController: HomeViewController?
  private var postRollingViewController: PostRollingViewController?

  struct Dependency {
    let injector: DependencyResolvable
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.injector = dependency.injector
  }

  // MARK: Methods
  public func create(scene: Scene) -> UIViewController {
    let coordinator = injector.resolve(AppCoordinatorType.self)

    switch scene {
    case .signIn:
      let useCase = injector.resolve(SignInUseCaseType.self)
      let reactorDependency: SignInReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase
      )
      let reactor: SignInReactor = .init(dependency: reactorDependency)
      let signInViewController: SignInViewController = .init(reactor: reactor)
      return signInViewController

    case .search:
      let searchViewController: UIViewController = .init(nibName: nil, bundle: nil)
      return searchViewController

    case let .postRolling(videoPosts, currentIndex):
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
      postRollingViewController.delegate = homeViewController
      self.postRollingViewController = postRollingViewController
      return postRollingViewController

    case .tab:
      let tabBarController: PhoChakTabBarController = .init(nibName: nil, bundle: nil)
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
      self.homeViewController = homeViewController

      let videoUploadViewController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadViewController.tabBarItem = .init(
        title: nil,
        image: nil,
        selectedImage: nil
      )

      let myPageViewController: MyPageViewController = .init(nibName: nil, bundle: nil)
      myPageViewController.tabBarItem = .init(
        title: nil,
        image: .createImage(.tab_profile),
        selectedImage: .createImage(.tab_profile_selected)
      )

      tabBarController.setViewControllers(
        [
          UINavigationController(rootViewController: homeViewController),
          UINavigationController(rootViewController: videoUploadViewController),
          UINavigationController(rootViewController: myPageViewController)
        ],
        animated: false
      )

      return tabBarController
    }
  }
}
