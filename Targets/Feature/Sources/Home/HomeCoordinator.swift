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
  func createNavWrappedViewController() -> UINavigationController
}

final class HomeCoordinator: HomeCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private let sceneFactory: SceneFactoryType
  private var homeViewController: HomeViewController?

  // MARK: Dependency
  struct Dependency {
    let router: UINavigationController
    let sceneFactory: SceneFactoryType
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.children = []
    self.router = dependency.router
    self.sceneFactory = dependency.sceneFactory
  }

  // MARK: Methods
  func start() {}

  func createNavWrappedViewController() -> UINavigationController {
    let viewController = sceneFactory.create(scene: .home)
    self.homeViewController = viewController as? HomeViewController
    return .init(rootViewController: viewController)
  }
}
