//
//  SceneFactory.swift
//  Feature
//
//  Created by Ian on 2023/01/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import UIKit

public enum Scene {
  case tab
  case splash
  case signIn
  case termsWebView
  case search(query: String = "")
  case postRolling(videoPosts: [VideoPost], currentIndex: Int, enablePaging: Bool = true)
  case uploadVideoPost
  case profileSetting(originNickName: String)
  case blockedList
  case userPage(targetUserID: Int)
}

public protocol SceneFactoryType {
  func create(scene: Scene) -> UIViewController
}

final class SceneFactory: SceneFactoryType {

  // MARK: Properties
  private let injector: DependencyResolvable
  private var homeViewController: HomeViewController?
  private var postRollingViewController: PostRollingViewController?

  struct Dependency {
    let injector: DependencyResolvable
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.injector = dependency.injector
  }

  // MARK: Methods
  public func create(scene: Scene) -> UIViewController {
    let coordinator = injector.resolve(AppCoordinatorType.self)

    switch scene {
    case .signIn:
      let useCase = injector.resolve(SignInUseCaseType.self)
      let reactorDependency: SignInReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase
      )
      let reactor: SignInReactor = .init(dependency: reactorDependency)
      let signInViewController: SignInViewController = .init(reactor: reactor)
      return UINavigationController(rootViewController: signInViewController)

    case .termsWebView:
      let reactor: TermsWebViewReactor = .init(dependency: .init(coordinator: coordinator))
      let termsWebViewController: TermsWebViewController = .init(reactor: reactor)
      return termsWebViewController

    case .splash:
      let reactor: SplashReactor = .init(dependency: .init(coordinator: coordinator))
      let viewController: SplashViewController = .init(reactor: reactor)
      return viewController

    case .profileSetting(let originNickName):
      let useCase = injector.resolve(ProfileSettingUseCaseType.self)
      let reactorDependency: ProfileSettingReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase,
        originNickName: originNickName
      )
      let reactor: ProfileSettingReactor = .init(dependency: reactorDependency)
      let profileSettingViewController: ProfileSettingViewController = .init(reactor: reactor)
      return profileSettingViewController

    case .uploadVideoPost:
      let fileManager = injector.resolve(PhoChakFileManagerType.self)
      let useCase = injector.resolve(UploadVideoPostUseCaseType.self)
      let reactorDependency: UploadVideoPostReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase,
        fileManager: fileManager
      )
      let reactor: UploadVideoPostReactor = .init(dependency: reactorDependency)
      let uploadVideoPostViewController: UploadVideoPostViewController = .init(
        reactor: reactor,
        fileManager: fileManager
      )
      return uploadVideoPostViewController

    case .search(let query):
      let dependency: SearchReactor.Dependency = .init(
        coordinator: coordinator,
        searchVideoPostUseCase: injector.resolve(SearchVideoPostUseCaseType.self),
        fetchSearchAutocompletionListUsecase: injector.resolve(FetchSearchAutoCompletionListUseCaseType.self),
        query: query
      )
      let reactor: SearchReactor = .init(dependency: dependency)
      let searchViewController: SearchViewController = .init(reactor: reactor)
      searchViewController.hidesBottomBarWhenPushed = true
      return searchViewController

    case let .postRolling(videoPosts, currentIndex, enablePaging):
      let videoPostUseCase = injector.resolve(VideoPostUseCaseType.self)
      let postRollingViewController: PostRollingViewController = .init(
        reactor: .init(
          dependency: .init(
            coordinator: coordinator,
            videoPosts: videoPosts,
            useCase: videoPostUseCase,
            currentIndex: currentIndex,
            enablePaging: enablePaging
          )
        )
      )
      postRollingViewController.hidesBottomBarWhenPushed = true
      postRollingViewController.delegate = homeViewController
      self.postRollingViewController = postRollingViewController
      return postRollingViewController

    case .blockedList:
      let useCase = injector.resolve(BlockUseCaseType.self)
      let reactorDependency: BlockedListReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase
      )
      let reactor: BlockedListReactor = .init(dependency: reactorDependency)
      let blockedListViewContrller: BlockedListViewController = .init(reactor: reactor)
      return blockedListViewContrller

    case .userPage(let targetUserID):
      let useCase = injector.resolve(UserPageUseCaseType.self)
      let reactorDependency: UserPageReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase,
        targetUserID: targetUserID
      )
      let reactor: UserPageReactor = .init(dependency: reactorDependency)
      let userPageViewController: UserPageViewController = .init(reactor: reactor)
      return userPageViewController

    case .tab:
      let tabBarController: PhoChakTabBarController = .init(coordinator: coordinator)

      let videoPostUseCase = injector.resolve(VideoPostUseCaseType.self)
      let fetchProfileUseCase = injector.resolve(FetchProfileUseCaseType.self)
      let homeViewController: HomeViewController = .init(
        reactor: .init(
          dependency: .init(
            coordinator: coordinator,
            videoPostCase: videoPostUseCase,
            fetchProfileUseCase: fetchProfileUseCase
          )
        )
      )
      homeViewController.tabBarItem = .init(
        title: nil,
        image: UIImage(literal: .tab_home),
        selectedImage: UIImage(literal: .tab_home_selected)
      )
      self.homeViewController = homeViewController

      let dummyViewController: UIViewController = .init(nibName: nil, bundle: nil)
      dummyViewController.tabBarItem = .init(
        title: nil,
        image: UIImage(literal: .tab_videoUpload),
        selectedImage: UIImage(literal: .tab_videoUpload)
      )

      let reactorDependency: MyPageReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: injector.resolve(MyPageUseCaseType.self)
      )
      let myPageViewController: MyPageViewController = .init(reactor: .init(dependency: reactorDependency))
      myPageViewController.tabBarItem = .init(
        title: nil,
        image: UIImage(literal: .tab_profile),
        selectedImage: UIImage(literal: .tab_profile_selected)
      )

      tabBarController.setViewControllers(
        [
          UINavigationController(rootViewController: homeViewController),
          UINavigationController(rootViewController: dummyViewController),
          UINavigationController(rootViewController: myPageViewController)
        ],
        animated: false
      )

      return tabBarController
    }
  }
}
