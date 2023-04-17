//
//  HomeReactor.swift
//  Feature
//
//  Created by Ian on 2023/01/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
  
  // MARK: Properties
  private let depepdency: Dependency
  var initialState: State = .init(videoPosts: [], isLoading: false)
  private var isLastPage: Bool = false
  private var existVideoPostRequest: FetchVideoPostRequest?
  private (set) var alreadyExclamedSubject: PublishSubject<Void> = .init()
  
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
    case fetchInitialItems
    case fetchMoreItems(size: Int, currentIndex: Int)
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
    case updateDataSource(videoPosts: [VideoPost])
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setInitialVideoPosts([VideoPost])
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

    case .fetchInitialItems:
      return .concat([
        .just(.setLoading(true)),
        fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 10))
      ])
      
    case let .fetchMoreItems(size, currentIndex):
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
        .flatMapLatest { [weak self] isError -> Observable<Mutation> in
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
    case .setInitialVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case .setVideoPosts(let videoPosts):
      var updatedPosts = state.videoPosts
      updatedPosts.append(contentsOf: videoPosts)
      newState.videoPosts = updatedPosts

    case .updateVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case let .updateVideoPostLikeStatus(index, isLiked):
      guard var post = currentState.videoPosts[safe: index] else {
        return .init(videoPosts: [], isLoading: false)
      }
      post.isLiked = isLiked
      newState.videoPosts[index] = post
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }
    
    return newState
  }
}

// MARK: Private
private extension HomeReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if isLastPage {
      return .just(.setLoading(false))
    }

    return depepdency.useCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) in
        self?.isLastPage = isLastPage
        self?.existVideoPostRequest = request

        if request.lastID == nil {
          // 첫 데이터 요청시
          return Observable<Mutation>.concat([
            .just(.setInitialVideoPosts(videoPosts)),
            .just(.setLoading(false))
          ])
        } else {
          // 추가 데이터 요청시
          return Observable<Mutation>.concat([
            .just(.setVideoPosts(videoPosts)),
            .just(.setLoading(false))
          ])
        }
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

    if currentState.videoPosts[safe: index]?.isLiked ?? false {
      return depepdency.useCase.unLikeVideoPost(postID: postID)
        .flatMap { isSuccess -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: isSuccess ? false : true))
        }
    } else {
      return depepdency.useCase.likeVideoPost(postID: postID)
        .flatMap { isSuccess -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: isSuccess ? true : false))
        }
    }
  }
}
