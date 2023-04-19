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
  private(set) var currentIndex: Int
  private var existVideoPostRequest: FetchVideoPostRequest?
  private var isLastPage: Bool = false
  private (set) var alreadyExclamedSubject: PublishSubject<Void> = .init()

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
    case fetchItems(size: Int, currentIndex: Int)
  }

  enum Mutation {
    case setVideoPosts([VideoPost])
    case setVideoPostLikeStatus(index: Int, isLiked: Bool)
  }

  struct State {
    var videoPosts: [VideoPost]
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load:
      return .just(.setVideoPosts(dependency.videoPosts))

    case let .fetchItems(size, currentIndex):
      self.currentIndex = currentIndex

      if (currentIndex + 1 >= currentState.videoPosts.count - 3) {
        return fetchVideoPosts(
          request: .init(
            sortOption: .latest,
            lastID: currentState.videoPosts.last?.id ?? nil,
            pageSize: size
          )
        )
      }
      return .empty()

    case .exclameVideoPost(let postID):
      return dependency.useCase.exclameVideoPost(postID: postID)
        .flatMap { [weak self] isError -> Observable<Mutation> in
          if isError { self?.alreadyExclamedSubject.onNext(()) }
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

    case let .setVideoPostLikeStatus(index, isLiked):
      var updatedPosts = state.videoPosts
      updatedPosts[index].isLiked = isLiked
      newState.videoPosts = updatedPosts
    }

    return newState
  }
}

// MARK: - Private
private extension PostRollingReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if existVideoPostRequest == request && isLastPage {
      return .empty()
    }

    return dependency.useCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) in
        self?.isLastPage = isLastPage
        self?.existVideoPostRequest = request
        return Observable<Mutation>.just(.setVideoPosts(videoPosts))
      }
  }

  func updateVideoPostLikeStatus(postID: Int) -> Observable<Mutation> {
    guard let index = currentState.videoPosts.firstIndex(where: { $0.id == postID }) else {
      return .empty()
    }

    if currentState.videoPosts[index].isLiked {
      return dependency.useCase.unLikeVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .just(.setVideoPostLikeStatus(index: index, isLiked: false))
        }
    } else {
      return dependency.useCase.likeVideoPost(postID: postID)
        .flatMap { _ -> Observable<Mutation> in
          return .just(.setVideoPostLikeStatus(index: index, isLiked: true))
        }
    }
  }
}
