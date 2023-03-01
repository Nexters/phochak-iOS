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

    container.register(UploadVideoPostServiceType.self) { resolver in
      let fileManager = resolver.resolve(PhoChakFileManagerType.self)!
      return UploadVideoPostService(fileManager: fileManager)
    }

    container.register(ProfileServiceType.self) { _ in return ProfileService() }

    container.register(ProfileSettingServiceType.self) { _ in return ProfileSettingService() }
  }

  // MARK: Initializer
  public init() {}
}
