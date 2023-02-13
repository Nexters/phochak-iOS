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
  var initialState: State = .init(videoPosts: [], isLoading: false, sortOption: .latest(lastPostID: nil))
  
  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: VideoPostUseCaseType
  }
  
  // MARK: Initializer
  init(dependency: Dependency) {
    self.depepdency = dependency
  }
  
  enum Action {
    case tapSearchButton
    case tapVideoCell(index: Int)
    case fetchItems(size: Int)
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setVideoPosts([VideoPost])
  }
  
  struct State {
    var videoPosts: [VideoPost]
    var isLoading: Bool
    var sortOption: SortOption
  }
  
  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapSearchButton:
      return pushSearchScene()
      
    case .tapVideoCell(let index):
      return pushPostRollingScene(index: index)
      
    case .fetchItems(let size):
      return .concat([
        .just(.setLoading(true)),
        fetchVideoPosts(request: .init(sortOption: .latest(lastPostID: nil), pageSize: size))
      ])
      
    case .exclameVideoPost(let postID):
      return depepdency.useCase.exclameVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .empty()
        }
      
    case .likeVideoPost(let postID):
      return depepdency.useCase.likeVideoPost(postID: postID)
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
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }
    
    return newState
  }
}

// MARK: Private
private extension HomeReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    return depepdency.useCase.fetchVideoPosts(
      request: .init(
        sortOption: currentState.sortOption,
        pageSize: 6
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
    depepdency.coordinator.transition(
      to: .search,
      style: .push,
      animated: true,
      completion: nil
    )
    
    return .empty()
  }
  
  func pushPostRollingScene(index: Int) -> Observable<Mutation> {
    depepdency.coordinator.transition(
      to: .postRolling(videoPosts: currentState.videoPosts, currentIndex: index),
      style: .push,
      animated: false,
      completion: nil
    )
    
    return .empty()
  }
}
