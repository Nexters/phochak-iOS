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
    container.register(VideoPostServiceType.self) { _ in VideoPostService() }

    container.register(SignInServiceType.self) { _ in SignInService() }

    container.register(UploadVideoPostServiceType.self) { resolver in
      let fileManager = resolver.resolve(PhoChakFileManagerType.self)!
      return UploadVideoPostService(fileManager: fileManager)
    }

    container.register(ProfileServiceType.self) { _ in ProfileService() }

    container.register(ProfileSettingServiceType.self) { _ in ProfileSettingService() }

    container.register(BlockServiceType.self) { _ in BlockService() }

    container.register(SettingServiceType.self) { _ in SettingService() }

    container.register(SearchServiceType.self) { _ in SearchService() }
  }

  // MARK: Initializer
  public init() {}
}
