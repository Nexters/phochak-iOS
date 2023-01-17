//
//  TabBarCoordinator.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import Then

private enum Tabs: Int, CaseIterable {
  case home
  case videoUpload
  case profile

  var title: String {
    switch self {
    case .home:
      return "Home"
    case .videoUpload:
      return "Upload"
    case .profile:
      return "Profile"
    }
  }
}

public protocol TabBarCoordinatorType: CoordinatorType {

  // MARK: Properties
  var parentCoordinator: CoordinatorType? { get set }
}

public final class TabBarCoordinator: TabBarCoordinatorType {

  // MARK: Properties
  public weak var parentCoordinator: CoordinatorType?
  public var children: [CoordinatorType]
  public var router: UINavigationController
  private let tabBarController: PhoChakTabBarController = .init(nibName: nil, bundle: nil)
  private let sceneFactory: SceneFactory

  public struct Dependency {
    let router: UINavigationController
    let sceneFactory: SceneFactory

    public init(router: UINavigationController, sceneFactory: SceneFactory) {
      self.router = router
      self.sceneFactory = sceneFactory
    }
  }

  // MARK: Initializer
  public init(dependency: Dependency) {
    self.children = []
    self.router = dependency.router
    self.sceneFactory = dependency.sceneFactory
  }

  // MARK: Methods
  public func start() {
    setupTabBar()
    router.setViewControllers([tabBarController], animated: false)
  }
}

// MARK: - Private Extension
private extension TabBarCoordinator {
  func setupTabBar() {
    let homeCoordinator: HomeCoordinatorType = HomeCoordinator(
      dependency: .init(
        router: router,
        sceneFactory: sceneFactory
      )
    )
    homeCoordinator.parentCoordinator = self
    addchild(homeCoordinator)

    let videoUploadCoordinator: VideoUploadCoordinatorType = VideoUploadCoordinator(
      dependency: .init(
        router: router,
        sceneFactory: sceneFactory
      )
    )
    videoUploadCoordinator.parentCoordinator = self
    addchild(videoUploadCoordinator)

    let profileCoordinator: ProfileCoordinatorType = ProfileCoordinator(
      dependency: .init(
        router: router,
        sceneFactory: sceneFactory
      )
    )
    profileCoordinator.parentCoordinator = self
    addchild(profileCoordinator)

    let homeViewController: UINavigationController = homeCoordinator.startPush()
    let videoUploadViewController: UINavigationController = videoUploadCoordinator.startPush()
    let profileViewController: UINavigationController = profileCoordinator.startPush()

    let viewControllers = [homeViewController, videoUploadViewController, profileViewController]

     [homeViewController, videoUploadViewController, profileViewController]
      .enumerated()
      .forEach { index, viewController in
        guard let tab = Tabs(rawValue: index) else { return }
        viewController.tabBarItem = .init(title: tab.title, image: nil, selectedImage: nil)
      }

    tabBarController.setViewControllers(viewControllers, animated: false)
  }
}
