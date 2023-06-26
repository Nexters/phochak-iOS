//
//  TermsWebViewReactor.swift
//  Feature
//
//  Created by 한상진 on 2023/06/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import ReactorKit

final class TermsWebViewReactor: Reactor {

  // MARK: - Properties
  private let depepdency: Dependency
  var initialState: State = .init()

  struct Dependency {
    let coordinator: AppCoordinatorType
  }

  // MARK: - Initializer
  init(dependency: Dependency) {
    self.depepdency = dependency
  }

  enum Action {
    case tapBackButton
  }

  enum Mutation {}

  struct State {}

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapBackButton:
      depepdency.coordinator.close(style: .root, animated: true, completion: nil)
      return .empty()
    }
  }
}
