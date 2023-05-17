//
//  SplashReactor.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain

import ReactorKit

final class SplashReactor: Reactor {

  // MARK: Properties
  private let dependency: Dependency
  var initialState: State = .init()

  struct Dependency {
    let coordinator: AppCoordinatorType
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  enum Action {
    case showNextScene
  }

  struct State { }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Action> {
    switch action {
    case .showNextScene:
      let firstScene: Scene = AuthManager.load(authInfoType: .accessToken) == nil ? .signIn : .tab
      dependency.coordinator.start(from: firstScene)
    }
    return .empty()
  }
}
