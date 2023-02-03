//
//  ProfileSettingReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

// TODO: 추후 서버 API 배포되면 구현할 예정 
final class ProfileSettingReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init(isEnableComplete: false)

  // MARK: - Initializer
  init() {

  }

  enum Action {
    case tapCheckButton(nickName: String)
  }

  enum Mutation {
    case setIsEnableComplete(nickName: String)
  }

  struct State {
    var isEnableComplete: Bool
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapCheckButton(let nickName):
      return .just(.setIsEnableComplete(nickName: nickName))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setIsEnableComplete(let nickName):
      newState.isEnableComplete = nickName.count <= 10
    }

    return newState
  }
}
