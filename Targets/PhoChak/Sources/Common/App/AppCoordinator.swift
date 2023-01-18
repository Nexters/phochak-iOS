//
//  AppCoordinator.swift
//  PhoChak
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Feature
import UIKit

protocol AppCoordinatorType: CoordinatorType {}

final class AppCoordinator: AppCoordinatorType {

  // MARK: Properties
  var children: [CoordinatorType]
  var router: UINavigationController

  // MARK: Initializer
  init(router: UINavigationController) {
    self.children = []
    self.router = router
  }

  // MARK: Methods
  func start() {
    router.view.backgroundColor = .white
    startTabBar()
  }
}

// MARK: - Private Extension
private extension AppCoordinator {
  func startSignIn() {}

  func startTabBar() {
    let tabBarCoordinator: TabBarCoordinatorType = TabBarCoordinator(
      dependency: .init(router: router)
    )
    tabBarCoordinator.parentCoordinator = self
    addchild(tabBarCoordinator)

    tabBarCoordinator.start()
  }
}
