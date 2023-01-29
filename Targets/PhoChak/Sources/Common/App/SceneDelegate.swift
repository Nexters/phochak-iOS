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
    let navAppearance = UINavigationBarAppearance()
    navAppearance.configureWithOpaqueBackground()
    navAppearance.backgroundColor = .clear
    navAppearance.shadowColor = .clear
    navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    navAppearance.setBackIndicatorImage(.createImage(.back), transitionMaskImage: .createImage(.back))

    UINavigationBar.appearance().standardAppearance = navAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    UINavigationBar.appearance().barTintColor = .white
    UINavigationBar.appearance().backItem?.title = ""

    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithOpaqueBackground()
    tabBarAppearance.backgroundColor = .clear
    
    UITabBar.appearance().standardAppearance = tabBarAppearance
    UITabBar.appearance().backgroundColor = .clear
    UITabBar.appearance().tintColor = .white
  }
}
