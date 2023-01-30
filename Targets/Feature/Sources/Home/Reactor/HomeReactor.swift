//
//  HomeReactor.swift
//  Feature
//
//  Created by Ian on 2023/01/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class HomeReactor: Reactor {
  
  // MARK: Properties
  private let depepdency: Dependency
  var initialState: State = .init(videoPosts: [], isLoading: false)
  
  struct Dependency {
    let coordinaotr: AppCoordinatorType
    let useCase: HomeUseCaseType
  }
  
  // MARK: Initializer
  init(dependency: Dependency) {
    self.depepdency = dependency
  }
  
  enum Action {
    case tapSearchButton
    case tapVideoCell(index: Int)
    case fetchItems(count: Int)
  }

  enum Mutation {
    case setLoading(Bool)
    case setVideoPosts([VideoPost])
  }

  struct State {
    var videoPosts: [VideoPost]
    var isLoading: Bool
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapSearchButton:
      return pushSearchScene()

    case .tapVideoCell(let index):
      return pushPostRollingScene(index: index)

    case .fetchItems(let count):
      let lastVideoPostID: Int = currentState.videoPosts.last?.postID ?? 0

      return .concat([
        .just(.setLoading(true)),
        fetchVideoPosts(lastVideoPostID: lastVideoPostID, count: count)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }

    return newState
  }
}

// MARK: Private
private extension HomeReactor {
  func fetchVideoPosts(lastVideoPostID: Int, count: Int) -> Observable<Mutation> {
    return depepdency.useCase.fetchVideoPosts(
      request: .init(
        lastVideoPostID: lastVideoPostID,
        count: count
      )
    )
    .flatMap { videoPosts in
      Observable<Mutation>.concat([
        .just(.setVideoPosts(videoPosts)),
        .just(.setLoading(false))
      ])
    }
  }

  func pushSearchScene() -> Observable<Mutation> {
    depepdency.coordinaotr.transition(
      to: .search,
      style: .push,
      animated: true,
      completion: nil
    )

    return .empty()
  }

  func pushPostRollingScene(index: Int) -> Observable<Mutation> {
    depepdency.coordinaotr.transition(
      to: .postRolling(videoPosts: currentState.videoPosts, currentIndex: index),
      style: .push,
      animated: true,
      completion: nil
    )

    return .empty()
  }
}
