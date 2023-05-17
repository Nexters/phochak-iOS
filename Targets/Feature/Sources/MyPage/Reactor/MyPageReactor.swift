//
//  MyPageReactor.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Kingfisher
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
  private var isFirstAppeared: Bool = true
  private var existVideoPostRequest: FetchVideoPostRequest?

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: MyPageUseCaseType
  }

  enum Action {
    case viewWillAppear
    case fetchItems(size: Int)
    case updatePostsListFilter(postFilter: PostsFilterOption)
    case editProfileButtonTap
    case videoPostCellTap(postID: Int)
    case tapSignOutButton
    case tapLogoutButton
    case tapClearCacheButton
    case tapPostDeletionButton(indexNumber: Int)
  }

  enum Mutation {
    case setUser(user: User)
    case setLikedPosts(videoPosts: [VideoPost])
    case setUploadedPosts(videoPosts: [VideoPost])
    case clearPost
    case setPostFilter(postFilter: PostsFilterOption)
    case reSignIn
    case deletePost(indexNumber: Int)
  }

  struct State {
    var user: User?
    var likedPosts: [VideoPost]
    var uploadedPosts: [VideoPost]
    var postFilter: PostsFilterOption = .uploaded
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      isFirstAppeared = true
      let fetchUserProfile = dependency.useCase.fetchUserProfile(userID: "")
        .asObservable()
        .map { Mutation.setUser(user: $0) }

      let fetchUploadedPosts = fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 12, filterOption: .uploaded))
      let fetchLikedPosts = fetchVideoPosts(request: .init(sortOption: .latest, pageSize: 12, filterOption: .liked))

      return .concat([
        .just(.clearPost),
        fetchUserProfile,
        fetchUploadedPosts,
        fetchLikedPosts
      ])

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
        to: .profileSetting(originNickName: currentState.user?.nickname ?? ""),
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()

    case .videoPostCellTap(let postID):
      var videoPosts: [VideoPost]
      if currentState.postFilter == .liked {
        videoPosts = currentState.likedPosts.filter { !($0.isBlind) }
      } else {
        videoPosts = currentState.uploadedPosts.filter { !($0.isBlind) }
      }

      guard let currentIndex = videoPosts.firstIndex(where:  { $0.id == postID }) else {
        return .empty()
      }

      dependency.coordinator.transition(
        to: .postRolling(videoPosts: videoPosts, currentIndex: currentIndex),
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()

    case .tapSignOutButton:
      return dependency.useCase.signOut().map { .reSignIn }

    case .tapLogoutButton:
      return dependency.useCase.logout().map { .reSignIn }

    case .tapClearCacheButton:
      return Observable<Void>.just(())
        .flatMap { _ -> Observable<Mutation> in
          KingfisherManager.shared.cache.clearCache()
          KingfisherManager.shared.cache.clearMemoryCache()
          return .empty()
        }

    case .tapPostDeletionButton(let indexNumber):
      let postID = currentState.uploadedPosts[indexNumber].id
      return dependency.useCase.deleteVideoPost(postID: postID)
        .map { .deletePost(indexNumber: indexNumber) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setUser(let user):
      newState.user = user

    case .setUploadedPosts(let videoPosts):
      guard !videoPosts.isEmpty else {
        return newState
      }

      var uploadedPosts = isFirstAppeared ? [] : state.uploadedPosts
      isFirstAppeared = false

      videoPosts.forEach { videoPost in
        if let index = uploadedPosts.firstIndex(where: { $0.id == videoPost.id }) {
          if uploadedPosts[index] != videoPost {
            uploadedPosts[index] = videoPost
          }
        } else {
          uploadedPosts.append(videoPost)
        }
      }
      newState.uploadedPosts = uploadedPosts

    case .setLikedPosts(let videoPosts):
      guard !videoPosts.isEmpty else {
        return newState
      }

      var likedPosts = isFirstAppeared ? [] : state.likedPosts
      isFirstAppeared = false

      videoPosts.forEach { videoPost in
        if let index = likedPosts.firstIndex(where: { $0.id == videoPost.id }) {
          if likedPosts[index] != videoPost {
            likedPosts[index] = videoPost
          }
        } else {
          likedPosts.append(videoPost)
        }
      }
      newState.likedPosts = likedPosts

    case .clearPost:
      newState.uploadedPosts = []
      newState.likedPosts = []

    case .setPostFilter(let postFilter):
      newState.postFilter = postFilter
      isLastPage = false

    case .reSignIn:
      AuthManager.deleteTokens()
      NotificationCenter.default.post(name: .logout, object: nil)

    case .deletePost(let indexNumber):
      newState.uploadedPosts.remove(at: indexNumber)
    }

    return newState
  }
}

// MARK: - Private
private extension MyPageReactor {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<Mutation> {
    if isFirstAppeared {
      isLastPage = false
    }

    guard !isLastPage else {
      if request.filterOption == .liked {
        return .just(.setLikedPosts(videoPosts: []))
      } else {
        return .just(.setUploadedPosts(videoPosts: []))
      }
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
