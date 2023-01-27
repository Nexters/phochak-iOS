//
//  SceneDelegate.swift
//  PhoChak
//
//  Created by Ian on 2023/01/14.
//

import Core
import Domain
import Feature
import Service
import UIKit

import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: Properties
  var window: UIWindow?
  private var appCoordinator: AppCoordinatorType?
  private let injector: InjectorType = DependencyInjector(container: .init())

  // MARK: Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = .init(windowScene: windowScene)
    window?.makeKeyAndVisible()

    injector.assemble([
      ServiceAssembly(), DomainAssembly(), FeatureAssembly(injector: injector)
    ])

    setupAppearance()

    appCoordinator = AppCoordinator(dependency: .init(injector: injector))
    appCoordinator?.start(from: .tab)
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - Extension
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
