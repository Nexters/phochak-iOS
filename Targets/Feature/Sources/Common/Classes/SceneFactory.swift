//
//  SceneFactory.swift
//  PhoChak
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

enum Scene {
  case login
  case home
  case videoUpload
  case profile
}

protocol SceneFactoryType {
  func create(scene: Scene) -> UIViewController
}

public final class SceneFactory: SceneFactoryType {

  // TODO: 생성시 DIContainer 주입받기.
  // DIContainer를 기반으로 Scene에 따른 의존성 객체들을 resolve하여 생성한 Scene을 반환한다.
  public init() {}

  // MARK: Methods
  func create(scene: Scene) -> UIViewController {
    switch scene {
    case .login:
      return UIViewController()
    case .home:
      let homeViewController: HomeViewController = .init(nibName: nil, bundle: nil)
      homeViewController.title = "Home"
      return homeViewController
    case .videoUpload:
      let videoUploadController: VideoUploadViewController = .init(nibName: nil, bundle: nil)
      videoUploadController.title = "Upload"
      return videoUploadController
    case .profile:
      let profileViewController: ProfileViewController = .init(nibName: nil, bundle: nil)
      profileViewController.title = "Profile"
      return profileViewController
    }
  }
}
