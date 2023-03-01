//
//  MyPageReactor.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class MyPageReactor: Reactor {

  enum Section: Int, CaseIterable {
    case profile
    case posts
  }

  // MARK: Properties
  var initialState: State = .init(likedPosts: [], uploadedPosts: [])
  private let dependency: Dependency
  private var isLastPage: Bool = false
  private var existVideoPostRequest: FetchVideoPostRequest?

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: MyPageUseCaseType
  }

  // MARK: Initializer

  enum Action {
    case viewWillAppear
    case fetchItems(size: Int)
    case updatePostsListFilter(postFilter: PostsFilterOption)
    case editProfileButtonTap
    case videoPostCellTap(videoPost: VideoPost)
  }

  enum Mutation {
    case setUser(user: User)
    case setLikedPosts(videoPosts: [VideoPost])
    case setUploadedPosts(videoPosts: [VideoPost])
    case setPostFilter(postFilter: PostsFilterOption)
  }

  struct State {
    var user: User?
    var likedPosts: [VideoPost]
    var uploadedPosts: [VideoPost]
    var postFilter: PostsFilterOption = .uploaded
  }

  func mutate(action: Action) -> Observable<Mutation> {
    let fetchUserProfile = dependency.useCase.fetchUserProfile(userID: "")
      .asObservable()
      .map { Mutation.setUser(user: $0) }

    let fetchUploadedPosts = fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 12, filterOption: .uploaded))
    let fetchLikedPosts = fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 12, filterOption: .liked))

    switch action {
    case .viewWillAppear:
      return Observable.merge(fetchUserProfile, fetchUploadedPosts, fetchLikedPosts)

    case let .fetchItems(size):
      let postFilter = currentState.postFilter
      let lastPostID: Int
      if postFilter == .liked {
        lastPostID = currentState.likedPosts.last?.id ?? 0
      } else {
        lastPostID = currentState.uploadedPosts.last?.id ?? 0
      }
      return fetchVideoPosts(
        request: .init(
          sortOption: .latest, lastID: lastPostID, pageSize: size, filterOption: postFilter
        )
      )

    case .updatePostsListFilter(let postFilter):
      return .just(.setPostFilter(postFilter: postFilter))

    case .editProfileButtonTap:
      dependency.coordinator.transition(
        to: .profileSetting,
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()

    case .videoPostCellTap(let videoPost):
      var videoPosts: [VideoPost] = currentState.uploadedPosts
      if currentState.postFilter == .liked {
        videoPosts = currentState.likedPosts
      }
      guard let currentIndex = videoPosts.firstIndex(of: videoPost) else {
        return .empty()
      }

      dependency.coordinator.transition(
        to: .postRolling(videoPosts: videoPosts, currentIndex: currentIndex),
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
    case .setUser(let user):
      newState.user = user

    case .setUploadedPosts(let videoPosts):
      if state.uploadedPosts.first?.id != videoPosts.first?.id {
        var uploadedPosts = state.uploadedPosts
        uploadedPosts.append(contentsOf: videoPosts)
        newState.uploadedPosts = uploadedPosts
      }

    case .setLikedPosts(let videoPosts):
      if state.likedPosts.first?.id != videoPosts.first?.id {
        var likedPosts = state.likedPosts
        likedPosts.append(contentsOf: videoPosts)
        newState.likedPosts = likedPosts
      }

    case .setPostFilter(let postFilter):
      newState.postFilter = postFilter
    }

    return newState
  }
}

// MARK: - Private
private extension MyPageReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if existVideoPostRequest == request && isLastPage {
      return .empty()
    }

    return dependency.useCase.fetchVideoPosts(request: request)
      .flatMap { [weak self] (videoPosts, isLastPage) in
        self?.isLastPage = isLastPage
        self?.existVideoPostRequest = request

        if request.filterOption == .uploaded {
          return Observable<Mutation>.just(.setUploadedPosts(videoPosts: videoPosts))
        }

        return Observable<Mutation>.just(.setLikedPosts(videoPosts: videoPosts))
      }
  }
}
