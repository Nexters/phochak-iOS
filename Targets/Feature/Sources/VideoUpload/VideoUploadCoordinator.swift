//
//  UploadCoordinator.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

protocol VideoUploadCoordinatorType: CoordinatorType {

  // MARK: Properties
  var parentCoordinator: CoordinatorType? { get set }

  // MARK: Methods
  func startPush() -> UINavigationController
}

final class VideoUploadCoordinator: VideoUploadCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private let sceneFactory: SceneFactory

  // MARK: dependency
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
    router.pushViewController(sceneFactory.create(scene: .videoUpload), animated: true)
  }

  func startPush() -> UINavigationController {
    .init(rootViewController: sceneFactory.create(scene: .videoUpload))
  }
}
