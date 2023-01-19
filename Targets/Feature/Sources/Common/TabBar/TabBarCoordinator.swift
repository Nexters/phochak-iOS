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

  public struct Dependency {
    let router: UINavigationController

    public init(router: UINavigationController) {
      self.router = router
    }
  }

  // MARK: Initializer
  public init(dependency: Dependency) {
    self.children = []
    self.router = dependency.router
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
      dependency: .init(router: router, sceneFactory: SceneFactory.shared)
    )
    homeCoordinator.parentCoordinator = self
    addchild(homeCoordinator)

    let videoUploadCoordinator: VideoUploadCoordinatorType = VideoUploadCoordinator(
      dependency: .init(router: router, sceneFactory: SceneFactory.shared)
    )
    videoUploadCoordinator.parentCoordinator = self
    addchild(videoUploadCoordinator)

    let profileCoordinator: ProfileCoordinatorType = ProfileCoordinator(
      dependency: .init(router: router, sceneFactory: SceneFactory.shared)
    )
    profileCoordinator.parentCoordinator = self
    addchild(profileCoordinator)

    let homeViewController: UINavigationController = homeCoordinator.createNavWrappedViewController()
    let videoUploadViewController: UINavigationController = videoUploadCoordinator.createNavWrappedViewController()
    let profileViewController: UINavigationController = profileCoordinator.createNavWrappedViewController()

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
