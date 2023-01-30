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
    case .signIn:
      let useCase = injector.resolve(SignInUseCaseType.self)
      let coordinator = injector.resolve(AppCoordinatorType.self)

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

      // TODO: 추후 수정 예정
      let postRollingViewController: UIViewController = .init(nibName: nil, bundle: nil)
      return postRollingViewController

//      let coordinator = injector.resolve(AppCoordinatorType.self)
//      let postRollingViewController: PostRollingViewController = .init(
//        reactor: .init(
//          dependency: .init(
//            coordinator: coordinator,
//            videoPosts: videoPosts,
//            currentIndex: currentIndex
//          )
//        )
//      )
//      postRollingViewController.hidesBottomBarWhenPushed = true
//      return postRollingViewController

    case .tab:
      let tabBarController: PhoChakTabBarController = .init(nibName: nil, bundle: nil)

      let coordinator = injector.resolve(AppCoordinatorType.self)
      let homeUseCase = injector.resolve(HomeUseCaseType.self)
      let homeViewController: HomeViewController = .init(
        reactor: .init(
          dependency: .init(
            coordinaotr: coordinator,
            useCase: homeUseCase
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
