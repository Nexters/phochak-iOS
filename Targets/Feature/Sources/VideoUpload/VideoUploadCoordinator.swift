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
  func createNavWrappedViewController() -> UINavigationController
}

final class VideoUploadCoordinator: VideoUploadCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private let sceneFactory: SceneFactoryType

  // MARK: dependency
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
    .init(rootViewController: sceneFactory.create(scene: .videoUpload))
  }
}
