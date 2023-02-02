//
//  DependencyInjector.swift
//  PhoChak
//
//  Created by Ian on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Swinject

public protocol DependencyAssemblable {
  func assemble(_ assemblyList: [Assembly])
  func register<T>(_ serviceType: T.Type, _ object: T)
}

public protocol DependencyResolvable {
  func resolve<T>(_ serviceType: T.Type) -> T
}

public typealias InjectorType = DependencyAssemblable & DependencyResolvable

public final class DependencyInjector: InjectorType {

  // MARK: Properties
  private let container: Container

  // MARK: Initializer
  public init(container: Container) {
    self.container = container
  }

  // MARK: Methods
  public func resolve<T>(_ serviceType: T.Type) -> T {
    container.resolve(serviceType)!
  }

  public func resolve<T>(_ serviceType: T.Type, name: String?) -> T {
    container.resolve(serviceType, name: name)!
  }

  public func register<T>(_ serviceType: T.Type, _ object: T) {
    container.register(serviceType) { _ in object }
  }

  public func assemble(_ assemblyList: [Assembly]) {
    assemblyList.forEach {
      $0.assemble(container: container)
    }
  }
}
