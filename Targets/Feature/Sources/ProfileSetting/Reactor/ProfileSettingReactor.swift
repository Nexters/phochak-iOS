//
//  ProfileSettingReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import ReactorKit

// TODO: 추후 서버 API 배포되면 구현할 예정 
final class ProfileSettingReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init(isEnableComplete: false, isError: false)
  let isDuplicatedSubject: PublishSubject<Bool> = .init()
  private let dependency: Dependency
  private (set) var currentNickName: String

  struct Dependency {
    let coordinator: AppCoordinatorType
    let useCase: ProfileSettingUseCaseType
    let originNickName: String
  }

  // MARK: - Initializer
  init(dependency: Dependency) {
    self.dependency = dependency
    currentNickName = dependency.originNickName
  }

  enum Action {
    case inputNickName(String)
    case tapCheckButton
    case tapCompleteButton
    case tapAlertAcceptButton
  }

  enum Mutation {
    case setIsEnableComplete(isEnable: Bool)
    case popViewController
    case setIsError(Bool)
  }

  struct State {
    var isEnableComplete: Bool
    var isError: Bool
  }

  // MARK: Methods
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapCheckButton:
      return dependency.useCase.checkDuplicationNickName(nickName: currentNickName)
        .map { [weak self] isDuplicated -> Mutation in
          self?.isDuplicatedSubject.onNext(isDuplicated)
          return .setIsEnableComplete(isEnable: !isDuplicated)
        }

    case .inputNickName(let nickName):
      currentNickName = nickName
      return .just(.setIsEnableComplete(isEnable: false))

    case .tapCompleteButton:
      return dependency.useCase.changeNickName(nickName: currentNickName)
        .flatMap { _ -> Observable<Mutation> in
          return .empty()
        }

    case .tapAlertAcceptButton:
      return .just(.setIsError(false))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setIsEnableComplete(let isEnable):
      newState.isEnableComplete = isEnable
    case .popViewController:
      dependency.coordinator.close(style: .pop, animated: true, completion: nil)
    case .setIsError(let isError):
      newState.isError = isError
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let eventMutation = dependency.useCase.profileSettingResultObservable
      .flatMap { event -> Observable<Mutation> in
      switch event {
      case .success: return .just(.popViewController)
      case .error: return .just(.setIsError(true))
      }
    }

    return .merge(mutation, eventMutation)
  }
}
