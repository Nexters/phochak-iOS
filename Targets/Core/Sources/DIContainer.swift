//
//  DIContainer.swift
//  Core
//
//  Created by 한상진 on 2023/01/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Swinject

public protocol RegistrantType {
  func register(container: Container)
}

public struct DIContainer {

  // MARK: Properties
  public static let shared: DIContainer = .init()
  public let container: Container = .init()
}
