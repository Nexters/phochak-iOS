//
//  SignInReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain

import ReactorKit

final class SignInReactor: Reactor {

  // MARK: - Properties
  private let depepdency: Dependency
  var initialState: State = .init()

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: SignInUseCaseType
  }

  // MARK: - Initializer
  init(dependency: Dependency) {
    self.depepdency = dependency
  }

  enum Action {
    case tapKakaoSignInButton
  }

  enum Mutation {
    case setUserToken(userToken: UserToken)
  }

  struct State {}

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapKakaoSignInButton:
      return depepdency.useCase.tryKakaoSignIn().map { .setUserToken(userToken: $0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setUserToken(let userToken):
      guard let accessTokenData = userToken.accessToken.data(using: .utf8),
            let refreshTokenData = userToken.refreshToken.data(using: .utf8)
      else { fatalError() }

      TokenManager.save(tokenType: .accessToken, data: accessTokenData)
      TokenManager.save(tokenType: .refreshToken, data: refreshTokenData)
      depepdency.coordinator.start(from: .tab)
    }

    return state
  }
}
