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
  func startPush() -> UINavigationController
}

final class HomeCoordinator: HomeCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private let sceneFactory: SceneFactory

  // MARK: Dependency
  struct Dependency {
    let router: UINavigationController
    let sceneFactory: SceneFactory
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.children = []
    self.router = dependency.router
    self.sceneFactory = dependency.sceneFactory
  }

  // MARK: Methods
  func start() {
    router.pushViewController(sceneFactory.create(scene: .home), animated: true)
  }

  func startPush() -> UINavigationController {
    .init(rootViewController: sceneFactory.create(scene: .home))
  }
}
