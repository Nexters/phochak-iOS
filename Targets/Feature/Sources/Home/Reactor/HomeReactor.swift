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
  private var isLastPage: Bool = false
  private var existVideoPostRequest: FetchVideoPostRequest?
  
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
    case fetchItems(size: Int, currentIndex: Int)
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
    case updateDataSource(videoPosts: [VideoPost])
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setVideoPosts([VideoPost])
    case updateVideoPosts([VideoPost])
    case updateVideoPostLikeStatus(index: Int, isLiked: Bool)
  }
  
  struct State {
    var videoPosts: [VideoPost]
    var isLoading: Bool
  }
  
  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapSearchButton:
      return pushSearchScene()
      
    case .tapVideoCell(let index):
      return pushPostRollingScene(index: index)
      
    case let .fetchItems(size, currentIndex):
      if (currentIndex + 1 >= currentState.videoPosts.count - 3) {
        return .concat([
          .just(.setLoading(true)),
          fetchVideoPosts(
            request: .init(
              sortOption: .latest,
              lastID: currentState.videoPosts.last?.id ?? nil,
              pageSize: size
            )
          )
        ])
      }
      return .empty()

    case .updateDataSource(let videoPosts):
      return .just(.updateVideoPosts(videoPosts))

    case .exclameVideoPost(let postID):
      return depepdency.useCase.exclameVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .empty()
        }
      
    case .likeVideoPost(let postID):
      return updateVideoPostLikeStatus(postID: postID)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setVideoPosts(let videoPosts):
      var updatedPosts = state.videoPosts
      updatedPosts.append(contentsOf: videoPosts)
      newState.videoPosts = updatedPosts

    case .updateVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case let .updateVideoPostLikeStatus(index, isLiked):
      var updatedPosts = state.videoPosts
      updatedPosts[index].isLiked = isLiked
      newState.videoPosts = updatedPosts
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }
    
    return newState
  }
}

// MARK: Private
private extension HomeReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if existVideoPostRequest == request && isLastPage {
      return .just(.setLoading(false))
    }

    return depepdency.useCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) in
        self?.isLastPage = isLastPage
        self?.existVideoPostRequest = request
        return Observable<Mutation>.concat([
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

  func updateVideoPostLikeStatus(postID: Int) -> Observable<Mutation> {
    guard let index = currentState.videoPosts.firstIndex(where: { $0.id == postID }) else {
      return .empty()
    }

    if currentState.videoPosts[index].isLiked {
      return depepdency.useCase.unLikeVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: false))
        }
    } else {
      return depepdency.useCase.likeVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: true))
        }
    }
  }
}
