//
//  FeatureAssembly.swift
//  Feature
//
//  Created by Ian on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core

import Swinject

public struct FeatureAssembly: Assembly {

  // MARK: Properties
  private let injector: InjectorType

  // MARK: Methods
  public func assemble(container: Container) {
    container.register(AppCoordinatorType.self) { _ in
      AppCoordinator(dependency: .init(injector: injector))
    }
  }

  // MARK: Initializer
  public init(injector: InjectorType) {
    self.injector = injector
  }
}
