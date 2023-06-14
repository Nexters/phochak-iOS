//
//  BlockedListReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class BlockedListReactor: Reactor {

  // MARK: Properties
  var initialState: State = .init()
  private let dependency: Dependency

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: BlockUseCaseType
  }

  enum Action {
    case viewWillAppear
    case tapBlockedUser(indexPath: Int)
  }

  enum Mutation {
    case setBlockedUsers(users: [User])
  }

  struct State {
    var blockedUsers: [User] = []
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return dependency.useCase.fetchBlockedList().map { .setBlockedUsers(users: $0) }

    case .tapBlockedUser(let indexPath):
      let targetUserID: Int = currentState.blockedUsers[indexPath].id

      dependency.coordinator.transition(
        to: .userPage(targetUserID: targetUserID),
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setBlockedUsers(let users):
      newState.blockedUsers = users
    }

    return newState
  }
}
