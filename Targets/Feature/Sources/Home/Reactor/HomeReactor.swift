//
//  HomeReactor.swift
//  Feature
//
//  Created by Ian on 2023/01/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
  
  // MARK: Properties
  private let dependency: Dependency
  var initialState: State = .init()
  private var isLastPage: Bool = false
  private (set) var alreadyExclamedSubject: PublishSubject<Void> = .init()
  
  struct Dependency {
    let coordinator: AppCoordinatorType
    let videoPostCase: VideoPostUseCaseType
    let fetchProfileUseCase: FetchProfileUseCaseType
  }
  
  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  enum Action {
    case fetchUserProfile
    case pushProfileSettingScene
    case tapSearchButton
    case tapVideoCell(index: Int)
    case fetchInitialItems
    case fetchMoreItems(size: Int, currentIndex: Int)
    case exclameVideoPost(postID: Int)
    case likeVideoPost(postID: Int)
    case updateDataSource(videoPosts: [VideoPost])
    case refresh
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setInitialVideoPosts([VideoPost])
    case setMoreFetchedVideoPosts([VideoPost])
    case updateVideoPosts([VideoPost])
    case updateVideoPostLikeStatus(index: Int, isLiked: Bool)
    case setRefreshStatus(Bool)
    case setProfileGuide(String)
    case removeExclamedPosts(postID: Int)
  }
  
  struct State {
    var videoPosts: [VideoPost] = []
    var isLoading: Bool = false
    var didRefresh: Bool = false
    var isNeededProfileGuide: Bool = false
  }
  
  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchUserProfile:
      return fetchUserProfile()

    case .pushProfileSettingScene:
      return pushProfileSettingScene()

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
      return dependency.videoPostCase.exclameVideoPost(postID: postID)
        .flatMapLatest { [weak self] isError -> Observable<Mutation> in
          if isError {
            self?.alreadyExclamedSubject.onNext(())
            return .empty()
          } else {
            return .just(.removeExclamedPosts(postID: postID))
          }
        }

    case .likeVideoPost(let postID):
      return updateVideoPostLikeStatus(postID: postID)

    case .refresh:
      return .concat([
        .just(.setLoading(true)),
        fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 10)),
        .just(.setLoading(false)),
        .just(.setRefreshStatus(true)),
        .just(.setRefreshStatus(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setProfileGuide(let nickName):
      newState.isNeededProfileGuide = nickName.contains("#")

    case .setInitialVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case .setMoreFetchedVideoPosts(let videoPosts):
      var updatedPosts = state.videoPosts
      updatedPosts.append(contentsOf: videoPosts)
      newState.videoPosts = updatedPosts

    case .updateVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case let .updateVideoPostLikeStatus(index, isLiked):
      guard var post = currentState.videoPosts[safe: index] else {
        return .init(videoPosts: [], isLoading: false, isNeededProfileGuide: false)
      }
      post.isLiked = isLiked
      newState.videoPosts[index] = post
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading

    case .setRefreshStatus(let didRefresh):
      newState.didRefresh = didRefresh

    case .removeExclamedPosts(let postID):
      // 신고된 게시글 유저에게 보여지지 않게 하기.
      if let index = newState.videoPosts.firstIndex(where: { $0.id == postID}) {
        newState.videoPosts.remove(at: index)
      }
    }
    
    return newState
  }
}

// MARK: Private
private extension HomeReactor {
  func fetchUserProfile() -> Observable<Mutation> {
    guard AuthManager.load(authInfoType: .isFirstSignIn) == nil else {
      return .empty()
    }

    AuthManager.save(authInfoType: .isFirstSignIn, data: Data([1]))
    return dependency.fetchProfileUseCase.fetchUserProfile(userID: "")
      .map { .setProfileGuide($0.nickname) }
  }

  func pushProfileSettingScene() -> Observable<Mutation> {
    dependency.coordinator.transition(
      to: .profileSetting(originNickName: ""),
      style: .push,
      animated: true,
      completion: nil
    )

    return .empty()
  }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if isLastPage {
      return .just(.setLoading(false))
    }

    return dependency.videoPostCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) in
        self?.isLastPage = isLastPage

        if request.lastID == nil {
          // 첫 데이터 요청시
          return Observable<Mutation>.concat([
            .just(.setInitialVideoPosts(videoPosts)),
            .just(.setLoading(false))
          ])
        } else {
          // 추가 데이터 요청시
          return Observable<Mutation>.concat([
            .just(.setMoreFetchedVideoPosts(videoPosts)),
            .just(.setLoading(false))
          ])
        }
      }
  }
  
  func pushSearchScene() -> Observable<Mutation> {
    dependency.coordinator.transition(
      to: .search,
      style: .push,
      animated: true,
      completion: nil
    )
    
    return .empty()
  }
  
  func pushPostRollingScene(index: Int) -> Observable<Mutation> {
    dependency.coordinator.transition(
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
      return dependency.videoPostCase.unLikeVideoPost(postID: postID)
        .flatMap { isSuccess -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: isSuccess ? false : true))
        }
    } else {
      return dependency.videoPostCase.likeVideoPost(postID: postID)
        .flatMap { isSuccess -> Observable<Mutation> in
          return .just(.updateVideoPostLikeStatus(index: index, isLiked: isSuccess ? true : false))
        }
    }
  }
}
