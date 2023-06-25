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
  var isFirstSignIn: Bool = AuthManager.load(authInfoType: .isFirstSignIn) == nil

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
    case receiveAppleSigninAuthCode(token: String)
    case tapShowTermsButton
  }

  enum Mutation {
    case setUserToken(userToken: UserToken)
  }

  struct State {}

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapKakaoSignInButton:
      return depepdency.useCase.tryKakaoSignIn().map { .setUserToken(userToken: $0) }

    case .receiveAppleSigninAuthCode(let token):
      return depepdency.useCase.tryAppleSignIn(token: token)
        .map { .setUserToken(userToken: $0) }

    case .tapShowTermsButton:
      depepdency.coordinator.transition(
        to: .termsWebView,
        style: .push,
        animated: true,
        completion: nil
      )

      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setUserToken(let userToken):
      guard let accessTokenData = userToken.accessToken.data(using: .utf8),
            let refreshTokenData = userToken.refreshToken.data(using: .utf8)
      else { fatalError() }

      AuthManager.save(authInfoType: .accessToken, data: accessTokenData)
      AuthManager.save(authInfoType: .refreshToken, data: refreshTokenData)
      depepdency.coordinator.start(from: .tab)
    }

    return state
  }
}
