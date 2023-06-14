//
//  UserPageReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/06/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class UserPageReactor: Reactor {

  // MARK: Properties
  var initialState: State = .init()
  private let dependency: Dependency
  private var isLastPage: Bool = false

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: UserPageUseCaseType
    let targetUserID: Int
  }

  enum Action {
    case viewWillAppear
    case videoPostCellTap(postID: Int)
    case tapBlockButton
    case fetchMoreItems
  }

  enum Mutation {
    case setNickname(String)
    case setBlockState(Bool)
    case setIsMe(Bool)
    case setInitialVideoPosts([VideoPost])
    case setMoreFetchedVideoPosts([VideoPost])
    case setLoading(Bool)
  }

  struct State {
    var nickname: String = ""
    var videoPosts: [VideoPost] = []
    var isMe: Bool = true
    var isLoading: Bool = false
    var isBlocked: Bool = false
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      isLastPage = false
      return .concat([
        .just(.setLoading(true)),
        fetchUserProfile(targetUserID: dependency.targetUserID),
        fetchVideoPosts(
          request: .init(
            sortOption: .latest,
            pageSize: 12,
            filterOption: .uploaded,
            targetUserID: dependency.targetUserID
          )
        ),
        .just(.setLoading(false))
      ])

    case .videoPostCellTap(let postID):
      let videoPosts: [VideoPost] = currentState.videoPosts.filter { !($0.isBlind) }

      guard let currentIndex = videoPosts.firstIndex(where:  { $0.id == postID }) else {
        return .empty()
      }

      dependency.coordinator.transition(
        to: .postRolling(videoPosts: videoPosts, currentIndex: currentIndex, enablePaging: false),
        style: .push,
        animated: true,
        completion: nil
      )

      return .empty()

    case .tapBlockButton:
      isLastPage = false
      return .concat([
        .just(.setLoading(true)),
        currentState.isBlocked ? unBlockUser() : blockUser(),
        fetchVideoPosts(
          request: .init(
            sortOption: .latest,
            pageSize: 12,
            filterOption: .uploaded,
            targetUserID: dependency.targetUserID
          )
        ),
        .just(.setLoading(false))
      ])

    case .fetchMoreItems:
      guard let lastPostID = currentState.videoPosts.last?.id,
            !isLastPage else {
        return .empty()
      }

      return .concat([
        .just(.setLoading(true)),
        fetchVideoPosts(
          request: .init(
            sortOption: .latest,
            lastID: lastPostID,
            pageSize: 3,
            filterOption: .uploaded,
            targetUserID: dependency.targetUserID
          )
        ),
        .just(.setLoading(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setNickname(let nickname):
      newState.nickname = nickname

    case .setIsMe(let isMe):
      newState.isMe = isMe

    case .setBlockState(let state):
      newState.isBlocked = state

    case .setInitialVideoPosts(let videoPosts):
      newState.videoPosts = videoPosts

    case .setMoreFetchedVideoPosts(let videoPosts):
      var updatedPosts = state.videoPosts
      updatedPosts.append(contentsOf: videoPosts)
      newState.videoPosts = updatedPosts

    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }

    return newState
  }
}

private extension UserPageReactor {
  func fetchUserProfile(targetUserID: Int) -> Observable<Mutation> {
    return dependency.useCase.fetchUserProfile(userID: String(targetUserID))
      .flatMap { userProfile in
        return Observable<Mutation>.concat([
          .just(.setNickname(userProfile.nickname)),
          .just(.setIsMe(userProfile.isMe ?? false)),
          .just(.setBlockState(userProfile.isBlocked ?? false))
        ])
      }
  }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    guard !isLastPage else {
      return .just(.setLoading(false))
    }

    return dependency.useCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) -> Observable<Mutation> in
        self?.isLastPage = isLastPage

        if request.lastID == nil {
          return .just(.setInitialVideoPosts(videoPosts))
        } else {
          return .just(.setMoreFetchedVideoPosts(videoPosts))
        }
      }
  }

  func blockUser() -> Observable<Mutation> {
    return dependency.useCase.blockUser(userID: dependency.targetUserID)
      .flatMap { _ -> Observable<Mutation> in
        .just(.setBlockState(true))
      }
  }

  func unBlockUser() -> Observable<Mutation> {
    return dependency.useCase.unBlockUser(userID: dependency.targetUserID)
      .flatMap { _ -> Observable<Mutation> in
        .just(.setBlockState(false))
      }
  }
}
