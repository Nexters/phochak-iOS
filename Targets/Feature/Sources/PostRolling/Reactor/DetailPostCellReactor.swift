//
//  DetailPostCellReactor.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

final class DetailPostCellReactor: Reactor {

  // MARK: Properties
  var initialState: State = .init(videoPost: nil)
  private(set) var videoPost: VideoPost

  // MARK: Initializer
  init(videoPost: VideoPost) {
    self.videoPost = videoPost
  }

  enum Action {
    case load(videoPost: VideoPost)
  }

  enum Mutation {
    case setVideoPost(VideoPost)
  }

  struct State {
    var videoPost: VideoPost?
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load(let videoPost):
      return .just(.setVideoPost(videoPost))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setVideoPost(let videoPost):
      newState.videoPost = videoPost
    }

    return newState
  }
}
