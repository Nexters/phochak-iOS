//
//  PhoChakTabBarController.swift
//  Feature
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

final class PhoChakTabBarController: UITabBarController {

  // MARK: Properties
  private weak var coordinator: AppCoordinatorType?

  // MARK: Initializer
  public init(coordinator: AppCoordinatorType) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self
  }
}

// MARK: - Private
extension PhoChakTabBarController: UITabBarControllerDelegate {

  // MARK: Methods
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    let nextTabIndex = tabBarController.viewControllers?.firstIndex(of: viewController)

    guard nextTabIndex == 1 else { return true }

    coordinator?.transition(to: .uploadVideoPost, style: .modal, animated: true, completion: nil)
    return false
  }
}
