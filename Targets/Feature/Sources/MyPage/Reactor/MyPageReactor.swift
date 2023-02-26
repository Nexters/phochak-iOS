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

  enum PostsFilter {
    case uploaded
    case liked
  }

  // MARK: Properties
  var initialState: State = .init(likedPosts: [], uploadedPosts: [])
  private let dependency: Dependency

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
    case filterButtonTap(postFilter: PostsFilter)
  }

  enum Mutation {
    case setUser(user: User)
    case setLikedPosts(videoPosts: [VideoPost])
    case setUploadedPosts(videoPosts: [VideoPost])
  }

  struct State {
    var user: User?
    var likedPosts: [VideoPost]
    var uploadedPosts: [VideoPost]
    var postFilter: PostsFilter = .uploaded
  }

  func mutate(action: Action) -> Observable<Mutation> {
    let fetchUserProfile = dependency.useCase.fetchUserProfile(userID: "")
      .asObservable()
      .map { Mutation.setUser(user: $0) }

    let fetchUploadedPosts = dependency.useCase.fetchVideoPosts(request: .init(sortOption: .latest, filterOption: .uploaded))
      .asObservable()
      .map { Mutation.setUploadedPosts(videoPosts: $0.posts) }

    let fetchLikedPosts = dependency.useCase.fetchVideoPosts(request: .init(sortOption: .latest, filterOption: .liked))
      .asObservable()
      .map { Mutation.setLikedPosts(videoPosts: $0.posts) }

    switch action {
    case .viewWillAppear:
      return Observable.merge(fetchUserProfile, fetchUploadedPosts, fetchLikedPosts)

    case .filterButtonTap(let postFilter):
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setUser(let user):
      newState.user = user

    case .setUploadedPosts(let uploadedPosts):
      newState.uploadedPosts = uploadedPosts

    case .setLikedPosts(let likedPosts):
      newState.likedPosts = likedPosts
    }

    return newState
  }
}
