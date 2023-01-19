//
//  SceneDelegate.swift
//  PhoChak
//
//  Created by Ian on 2023/01/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: Properties
  var window: UIWindow?
  private var appCoordinator: AppCoordinatorType?
  private var router: UINavigationController?

  // MARK: Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = .init(windowScene: windowScene).then {
      $0.makeKeyAndVisible()
    }

    router = .init(nibName: nil, bundle: nil).then {
      $0.navigationBar.isHidden = true
    }
    window?.rootViewController = router

    guard let router = router else { return }
    setupAppearance()
    appCoordinator = AppCoordinator(router: router)
    appCoordinator?.start()
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}

private extension SceneDelegate {
  func setupAppearance() {
    if #available(iOS 15, *) {
      let navAppearance = UINavigationBarAppearance()
      navAppearance.configureWithOpaqueBackground()

      UINavigationBar.appearance().barTintColor = .black
      UINavigationBar.appearance().standardAppearance = navAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = navAppearance

      let tabBarAppearance = UITabBarAppearance()
      tabBarAppearance.configureWithOpaqueBackground()
      UITabBar.appearance().backgroundColor = .black
      UITabBar.appearance().tintColor = .white
    }
  }
}
