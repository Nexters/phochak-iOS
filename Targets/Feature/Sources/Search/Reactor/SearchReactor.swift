//
//  SearchReactor.swift
//  PhoChak
//
//  Created by 여정수 on 2023/05/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import RxSwift
import ReactorKit

final class SearchReactor: Reactor {

  // MARK: Properties
  var initialState: State = .init()
  private let dependency: Dependency
  private var isLastPage: Bool = false
  private var postCategory: PostCategory? = nil
  private(set) var isPaging: Bool = false

  struct Dependency {
    let coordinator: AppCoordinatorType
    let searchVideoPostUseCase: SearchVideoPostUseCaseType
    let fetchSearchAutocompletionListUsecase: FetchSearchAutoCompletionListUseCaseType
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  enum Action {
    case viewDidLoad
    case didEnterQuery(_ query: String)
    case tapCategoryButton(_ category: PostCategory, query: String?)
    case search(query: String)
    case tapVideoPost(_ index: Int)
    case fetchMoreItems(currentQuery: String?)
  }

  enum Mutation {
    case setVideoPost([VideoPost])
    case setAutoCompletionList([String])
    case setLoading(Bool)
    case appendVideoPosts([VideoPost])
  }

  struct State {
    var videoPosts: [VideoPost] = []
    var autoCompletionList: [String] = []
    var isLoading: Bool = false
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setLoading(true)),
        search(category: nil, query: nil),
        .just(.setLoading(false))
      ])

    case .didEnterQuery(let query):
      return fetchAutoCompletionList(query: query)
        .map { .setAutoCompletionList($0) }

    case let .tapCategoryButton(category, query):
      self.postCategory = category
      return .concat([
        .just(.setLoading(true)),
        search(category: category, query: query),
        .just(.setLoading(false))
      ])

    case .search(let query):
      isLastPage = false
      return .concat([
        .just(.setLoading(true)),
        search(category: postCategory, query: query),
        .just(.setLoading(false))
      ])

    case .tapVideoPost(let index):
      dependency.coordinator.transition(
        to: .postRolling(
          videoPosts: currentState.videoPosts,
          currentIndex: index),
        style: .push,
        animated: true,
        completion: nil
      )
      return .empty()

    case .fetchMoreItems(let currentQuery):
      guard !(isPaging || isLastPage) else {
        return .empty()
      }

      isPaging = true

      let lastID = currentState.videoPosts.last?.id
      return .concat([
        .just(.setLoading(true)),
        search(category: postCategory, query: currentQuery, lastID: lastID),
        .just(.setLoading(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setVideoPost(let videoPosts):
      newState.videoPosts = videoPosts

    case .setAutoCompletionList(let keywordList):
      newState.autoCompletionList = keywordList

    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .appendVideoPosts(let videoPosts):
      var posts = newState.videoPosts
      posts.append(contentsOf: videoPosts)
      newState.videoPosts = posts
      isPaging = false

    }

    return newState
  }
}

// MARK: - Private
private extension SearchReactor {
  func search(category: PostCategory?, query: String?, lastID: Int? = nil) -> Observable<Mutation> {
    return dependency.searchVideoPostUseCase.execute(request: .init(category: category, query: query, lastID: lastID, pageSize: 12))
      .do { [weak self] _, isLastPage in
        self?.isLastPage = isLastPage
      }
      .map { videoPosts, _ in
        if lastID != nil {
          return Mutation.appendVideoPosts(videoPosts)
        } else {
          return Mutation.setVideoPost(videoPosts)
        }
      }
  }

  func fetchAutoCompletionList(query: String) -> Observable<[String]> {
    dependency.fetchSearchAutocompletionListUsecase.execute(query)
      .asObservable()
  }
}
