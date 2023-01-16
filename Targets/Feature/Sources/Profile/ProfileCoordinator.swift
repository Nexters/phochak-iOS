//
//  ProfileCoordinator.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorType: CoordinatorType {

  // MARK: Properties
  var parentCoordinator: CoordinatorType? { get set }

  // MARK: Methods
  func startPush() -> ProfileViewController
}

final class ProfileCoordinator: ProfileCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private var profileViewController: ProfileViewController?

  // MARK: Initializer
  init(router: UINavigationController) {
    self.children = []
    self.router = router
  }

  // MARK: Methods
  func start() {
    let viewController: ProfileViewController = makeViewController()
    router.pushViewController(viewController, animated: true)
  }

  func startPush() -> ProfileViewController {
    makeViewController()
  }
}

// MARK: - Private Extension
private extension ProfileCoordinator {
  func makeViewController() -> ProfileViewController {
    let viewController: ProfileViewController = .init(nibName: nil, bundle: nil)
    self.profileViewController = viewController

    return viewController
  }
}
