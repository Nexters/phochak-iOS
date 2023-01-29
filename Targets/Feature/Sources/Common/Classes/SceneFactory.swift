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
  case home
  case search
  case postRolling(videoPosts: [VideoPost], currentIndex: Int)
  case videoUpload
  case profile

  var title: String {
    switch self {
    case .tab: return ""
    case .login: return "Login"
    case .home: return "Home"
    case .search: return ""
    case .videoUpload: return "Upload"
    case .profile: return "Profile"
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

    case .home:
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
      homeViewController.title = scene.title
      return homeViewController

    case .videoUpload:
      let videoUploadController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadController.title = scene.title
      return videoUploadController

    case .profile:
      let profileViewController: ProfileViewController = .init(nibName: nil, bundle: nil)
      profileViewController.title = scene.title
      return profileViewController

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
        title: Scene.home.title,
        image: .createImage(.tab_home),
        selectedImage: .createImage(.tab_home_selected)
      )

      let videoUploadViewController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadViewController.title = Scene.videoUpload.title
      videoUploadViewController.tabBarItem = .init(
        title: Scene.videoUpload.title,
        image: nil,
        selectedImage: nil
      )

      let profileViewController: ProfileViewController = .init(nibName: nil, bundle: nil)
      profileViewController.title = Scene.profile.title
      profileViewController.tabBarItem = .init(
        title: Scene.profile.title,
        image: nil,
        selectedImage: nil
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
