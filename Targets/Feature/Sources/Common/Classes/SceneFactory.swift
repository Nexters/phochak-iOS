//
//  SceneFactory.swift
//  Feature
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import UIKit

public enum Scene {
  case tab
  case login
  case home
  case videoUpload
  case profile

  var title: String {
    switch self {
    case .tab: return ""
    case .login: return "Login"
    case .home: return "Home"
    case .videoUpload: return "Upload"
    case .profile: return "Profile"
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
      let homeViewController: HomeViewController = .init(nibName: nil, bundle: nil)
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

    case .tab:
      let tabBarController: PhoChakTabBarController = .init(nibName: nil, bundle: nil)

      let homeViewController: HomeViewController = .init(nibName: nil, bundle: nil)
      homeViewController.title = Scene.home.title
      homeViewController.tabBarItem = .init(title: Scene.home.title, image: nil, selectedImage: nil)

      let videoUploadViewController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadViewController.title = Scene.videoUpload.title
      videoUploadViewController.tabBarItem = .init(title: Scene.videoUpload.title, image: nil, selectedImage: nil)

      let profileViewController: ProfileViewController = .init(nibName: nil, bundle: nil)
      profileViewController.title = Scene.profile.title
      profileViewController.tabBarItem = .init(title: Scene.profile.title, image: nil, selectedImage: nil)

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
