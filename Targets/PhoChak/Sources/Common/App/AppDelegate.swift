//
//  AppDelegate.swift
//  PhoChak
//
//  Created by Ian on 2023/01/14.
//

import UIKit

import KakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Methods
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    setupKakaoSDK()
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    guard AuthApi.isKakaoTalkLoginUrl(url) else { return false }

    return AuthController.rx.handleOpenUrl(url: url)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) { }
}

private extension AppDelegate {
  func setupKakaoSDK() {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let kakaoAppKey = infoDictionary["KAKAO_NATIVE_APP_KEY"],
          let appKey = kakaoAppKey as? String
    else { return }

    RxKakaoSDK.initSDK(appKey: appKey)
  }
}

