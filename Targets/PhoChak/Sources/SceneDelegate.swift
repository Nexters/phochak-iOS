//
//  SceneDelegate.swift
//  PhoChak
//
//  Created by Ian on 2023/01/14.
//

import Core
import Domain
import Feature
import Network
import Service
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: Properties
  var window: UIWindow?

  // MARK: Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let _ = (scene as? UIWindowScene) else { return }

    assembleDomain()
    assembleNetwork()
    assembleService()
    assembleFeature()
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - Extension
private extension SceneDelegate {
  func assembleDomain() {
    DomainAssembly().assemble(container: DIContainer.shared.container)
  }

  func assembleNetwork() {
    NetworkAssembly().assemble(container: DIContainer.shared.container)
  }

  func assembleService() {
    ServiceAssembly().assemble(container: DIContainer.shared.container)
  }

  func assembleFeature() {
    FeatureAssembly().assemble(container: DIContainer.shared.container)
  }
}
