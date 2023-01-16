//
//  HomeCoordinator.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

protocol HomeCoordinatorType: CoordinatorType {

  // MARK: Properties
  var parentCoordinator: CoordinatorType? { get set }

  // MARK: Methods
  func startPush() -> HomeViewController
}

final class HomeCoordinator: HomeCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private var homeViewController: HomeViewController?

  // MARK: Initializer
  init(router: UINavigationController) {
    self.children = []
    self.router = router
  }

  // MARK: Methods
  func start() {
    let viewController: HomeViewController = makeViewController()
    router.pushViewController(viewController, animated: true)
  }

  func startPush() -> HomeViewController {
    makeViewController()
  }
}

// MARK: - Private Extension
private extension HomeCoordinator {
  func makeViewController() -> HomeViewController {
    let viewController: HomeViewController = .init(nibName: nil, bundle: nil)
    self.homeViewController = viewController

    return viewController
  }
}
