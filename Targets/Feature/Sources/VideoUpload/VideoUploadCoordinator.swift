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
  func startPush() -> VideoUploadViewController
}

final class VideoUploadCoordinator: VideoUploadCoordinatorType {

  // MARK: Properties
  weak var parentCoordinator: CoordinatorType?
  var children: [CoordinatorType]
  var router: UINavigationController
  private var videoUploadViewController: VideoUploadViewController?

  // MARK: Initializer
  init(router: UINavigationController) {
    self.children = []
    self.router = router
  }

  // MARK: Methods
  func start() {
    let viewController: VideoUploadViewController = makeViewController()
    router.pushViewController(viewController, animated: true)
  }

  func startPush() -> VideoUploadViewController {
    makeViewController()
  }
}

// MARK: - Private Extension
private extension VideoUploadCoordinator {
  func makeViewController() -> VideoUploadViewController {
    let viewController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
    self.videoUploadViewController = viewController

    return viewController
  }
}
