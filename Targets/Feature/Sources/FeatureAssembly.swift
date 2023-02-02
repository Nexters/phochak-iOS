//
//  FeatureAssembly.swift
//  Feature
//
//  Created by Ian on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain

import Swinject

public struct FeatureAssembly: Assembly {

  // MARK: Properties
  private let injector: InjectorType

  // MARK: Methods
  public func assemble(container: Container) {
    container.register(AppCoordinatorType.self) { _ in
      AppCoordinator(dependency: .init(injector: injector))
    }

    container.register(SignInViewController.self) { resolver in
      let useCase = resolver.resolve(SignInUseCaseType.self)!
      let coordinator = resolver.resolve(AppCoordinatorType.self)!

      let reactorDependency: SignInReactor.Dependency = .init(
        coordinator: coordinator,
        useCase: useCase
      )
      let reactor: SignInReactor = .init(dependency: reactorDependency)
      let signInViewController: SignInViewController = .init(reactor: reactor)

      return signInViewController
    }
  }

  // MARK: Initializer
  public init(injector: InjectorType) {
    self.injector = injector
  }
}
