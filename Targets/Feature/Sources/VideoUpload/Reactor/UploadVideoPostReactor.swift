//
//  UploadVideoPostReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain

import ReactorKit

final class UploadVideoPostReactor: Reactor {

  // MARK: Properties
  var initialState: State = .init()
  private let depepdency: Dependency
  private var category: String?

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: UploadVideoPostUseCaseType
  }

  enum Action {
    case tapCloseButton
    case tapCategoryButton(category: String)
    case inputHashTag(tag: String)
    case tapHashTagDeletionButton(tag: String)
    case tapCompletionButton(videoFile: VideoFile)
    case tapAlertAcceptButton
  }

  enum Mutation {
    case dismiss
    case setCategory(category: String)
    case setHashTags(tag: String)
    case deleteHashTag(tag: String)
    case setIsEnableComplete
    case setIsLoading(Bool)
    case setIsError(Bool)
  }

  struct State {
    var isEnableComplete: Bool = false
    var hashTags: [String] = []
    var isLoading: Bool = false
    var isError: Bool = false
  }

  // MARK: Initializer
  init(dependency: Dependency) {
    self.depepdency = dependency
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapCloseButton:
      return .just(.dismiss)

    case .tapCategoryButton(let category):
      return .concat([
        .just(.setCategory(category: category)),
        .just(.setIsEnableComplete)
      ])

    case .inputHashTag(let tag):
      return .concat([
        .just(.setHashTags(tag: tag)),
        .just(.setIsEnableComplete)
      ])

    case .tapHashTagDeletionButton(let tag):
      return .concat([
        .just(.deleteHashTag(tag: tag)),
        .just(.setIsEnableComplete)
      ])

    case .tapCompletionButton(let videoFile):
      return .concat([
        .just(.setIsLoading(true)),
        uploadVideoPost(videoFile: videoFile)
      ])

    case .tapAlertAcceptButton:
      return .just(.setIsError(false))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .dismiss:
      PhoChakFileManager.shared.removeUploadedVideos()
      depepdency.coordinator.close(style: .dismiss, animated: true, completion: nil)

    case .setCategory(let category):
      self.category = category

    case .setHashTags(let tag):
      guard !newState.hashTags.contains(tag) else { break }
      newState.hashTags.append(tag)

    case .deleteHashTag(let tag):
      guard let removeIndex = currentState.hashTags.firstIndex(of: tag) else { break }
      newState.hashTags.remove(at: removeIndex)

    case .setIsEnableComplete:
      let isCategoryNotNil = category != nil
      let isHashTagsCountNotOver = state.hashTags.count <= 30
      newState.isEnableComplete = isCategoryNotNil && isHashTagsCountNotOver ? true : false

    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading

    case .setIsError(let isError):
      newState.isError = isError
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let eventMutation = depepdency.useCase.uploadVideoPostEvent.flatMap { event -> Observable<Mutation> in
      switch event {
      case .success:
        return .concat([
          .just(.setIsLoading(false)),
          .just(.dismiss)
        ])

      case .error:
        return .concat([
          .just(.setIsLoading(false)),
          .just(.setIsError(true))
        ])
      }
    }

    return .merge(mutation, eventMutation)
  }
}

// MARK: - Private
private extension UploadVideoPostReactor {

  // MARK: Methods
  func uploadVideoPost(videoFile: VideoFile) -> Observable<Mutation> {
    depepdency.useCase.uploadVideoPost(
      videoFile: videoFile,
      category: category ?? "",
      hashTags: currentState.hashTags
    )
    .flatMap { _ -> Observable<Mutation> in
      return .empty()
    }
  }
}
