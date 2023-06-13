//
//  SceneDelegate.swift
//  PhoChak
//
//  Created by Ian on 2023/01/14.
//

import AVFAudio
import Core
import Domain
import Feature
import Service
import UIKit

import KakaoSDKAuth
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

    setupAppearance()

    fileManagerAssembly()
    injector.assemble([ServiceAssembly(), DomainAssembly()])
    appCoordinator = AppCoordinator(dependency: .init(injector: injector))
    coordinatorAssembly(coordinator: appCoordinator!)

    appCoordinator?.start(from: .splash)

    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(.ambient, options: [.allowBluetooth])
    try? audioSession.setActive(true)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {
    let audioSession = AVAudioSession.sharedInstance()
    if audioSession.category != .ambient {
      try? audioSession.setCategory(.ambient, options: [.allowBluetooth])
      try? audioSession.setActive(true)
    }
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }
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
    navAppearance.setBackIndicatorImage(UIImage(literal: .back), transitionMaskImage: UIImage(literal: .back))

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

  func coordinatorAssembly(coordinator: AppCoordinatorType) {
    injector.register(AppCoordinatorType.self, coordinator)
  }

  func fileManagerAssembly() {
    let fileManager: PhoChakFileManager = .init()
    injector.register(PhoChakFileManagerType.self, fileManager)
  }
}
