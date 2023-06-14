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

  enum SwipeDirection {
    case left, right
  }

  // MARK: Properties
  private let dependency: Dependency
  var initialState: State = .init(videoPosts: [])
  private var existVideoPostRequest: FetchVideoPostRequest?
  private(set) var alreadyExclamedSubject: PublishSubject<Void> = .init()
  private var isLastPage: Bool = false
  private(set) var currentIndex: Int
  private(set) var isEnablePaging: Bool

  struct Dependency {
    let coordinator: AppCoordinatorType
    let videoPosts: [VideoPost]
    let useCase: VideoPostUseCaseType
    let currentIndex: Int
    let enablePaging: Bool
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
    self.currentIndex = dependency.currentIndex
    self.isEnablePaging = dependency.enablePaging
  }

  enum Action {
    case load
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
    case fetchItems(size: Int, currentIndex: Int)
    case didSwipe(direction: SwipeDirection)
    case tapBackButton
    case tapNicknameLabel(targetUserID: Int)
    case tapHashtag(_ tag: String)
  }

  enum Mutation {
    case setVideoPosts([VideoPost])
    case setVideoPostLikeStatus(index: Int, isLiked: Bool)
    case setCurrentIndex(value: Int)
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

    case .didSwipe(let direction):
      var currentIndex = currentIndex
      if direction == .left {
        currentIndex -= 1
      } else {
        currentIndex += 1
      }

      return .just(.setCurrentIndex(value: currentIndex))

    case .tapBackButton:
      dependency.coordinator.close(style: .pop, animated: false, completion: nil)
      return .empty()

    case .tapNicknameLabel(let targetUserID):
      dependency.coordinator.transition(
        to: .userPage(targetUserID: targetUserID),
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()

    case .tapHashtag(let query):
      dependency.coordinator.transition(to: .search(query: query), style: .push, animated: true, completion: nil)
      return .empty()
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

    case .setCurrentIndex(let value):
      currentIndex = value
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
