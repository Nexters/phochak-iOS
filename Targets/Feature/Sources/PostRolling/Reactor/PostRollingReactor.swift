//
//  PostRollingReactor.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class PostRollingReactor: Reactor {

  // MARK: Properties
  private let dependency: Dependency
  var initialState: State = .init(videoPosts: [])
  let currentIndex: Int

  struct Dependency {
    let coordinator: AppCoordinatorType
    let videoPosts: [VideoPost]
    let currentIndex: Int
    let useCase: VideoPostUseCaseType
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
    self.currentIndex = dependency.currentIndex
  }

  enum Action {
    case load
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
  }

  enum Mutation {
    case setVideoPosts([VideoPost])
  }

  struct State {
    var videoPosts: [VideoPost]
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load:
      return .just(.setVideoPosts(dependency.videoPosts))

    case .exclameVideoPost(let postID):
      return dependency.useCase.exclameVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .empty()
        }

    case .likeVideoPost(let postID):
      return dependency.useCase.likeVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .empty()
        }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts
    }

    return newState
  }
}
