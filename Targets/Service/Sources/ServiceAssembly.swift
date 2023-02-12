//
//  ServiceAssembly.swift
//  Service
//
//  Created by Ian on 2023/01/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain

import Swinject

public struct ServiceAssembly: Assembly {

  // MARK: Methods
  public func assemble(container: Container) {
    container.register(VideoPostServiceType.self) { _ in return VideoPostService() }

    container.register(SignInServiceType.self) { _ in return SignInService() }

    container.register(UploadVideoPostServiceType.self) { _ in return UploadVideoPostService() }
  }

  // MARK: Initializer
  public init() {}
}
