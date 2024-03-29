//
//  PhoChakTabBarController.swift
//  Feature
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import UIKit

@frozen enum PhoChakTab: Int {
  case home
  case upload
  case myPage
}

final class PhoChakTabBarController: UITabBarController, Alertable {

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

    addTokenObserver()
    delegate = self
  }
}

// MARK: - Extension
extension PhoChakTabBarController: UITabBarControllerDelegate {

  // MARK: Methods
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    guard let index = tabBarController.viewControllers?.firstIndex(of: viewController),
          let nextTab = PhoChakTab(rawValue: index) else {
      return false
    }

    switch nextTab {
    case .home:
      let homeVC = (viewController as? UINavigationController)?.topViewController as? HomeViewController
      if self.selectedIndex == nextTab.rawValue {
        homeVC?.refresh()
      }
      return true
    case .myPage:
      let mypageVC = (viewController as? UINavigationController)?.topViewController as? MyPageViewController
      if self.selectedIndex == nextTab.rawValue {
        mypageVC?.refresh()
      }
      return true
    case .upload:
      coordinator?.transition(to: .uploadVideoPost, style: .modal, animated: true, completion: nil)
      return false
    }
  }
}

// MARK: - Private
private extension PhoChakTabBarController {
  func addTokenObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(transitionToSignIn),
      name: .reSignIn,
      object: nil
    )
  }

  @objc private func transitionToSignIn() {
    presentAlert(
      type: .tokenExpired,
      okAction: { [weak self] in
        self?.coordinator?.start(from: .signIn)
      }
    )
  }
}
