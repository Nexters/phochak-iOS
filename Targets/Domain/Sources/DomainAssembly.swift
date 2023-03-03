//
//  DomainAssembly.swift
//  Domain
//
//  Created by Ian on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core

import Swinject

public struct DomainAssembly: Assembly {

  // MARK: Methods
  public func assemble(container: Container) {
    container.register(FetchVideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return FetchVideoPostUseCase(service: service)
    }

    container.register(ExclameVideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return ExclameVideoPostUseCase(service: service)
    }

    container.register(LikeVideoPostUseCase.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return LikeVideoPostUseCase(service: service)
    }

    container.register(VideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return VideoPostUseCase(service: service)
    }

    container.register(SignInUseCaseType.self) { resolver in
      let service = resolver.resolve(SignInServiceType.self)!
      return SignInUseCase(service: service)
    }

    container.register(UploadVideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(UploadVideoPostServiceType.self)!
      return UploadVideoPostUseCase(service: service)
    }

    container.register(FetchProfileUseCaseType.self) { resolver in
      let service = resolver.resolve(ProfileServiceType.self)!
      return FetchProfileUseCase(service: service)
    }

    container.register(MyPageUseCaseType.self) { resolver in
      let postsService = resolver.resolve(VideoPostServiceType.self)!
      let profileService = resolver.resolve(ProfileServiceType.self)!
      let settingService = resolver.resolve(SettingServiceType.self)!
      return MyPageUseCase(postsService: postsService, profileService: profileService, settingService: settingService)
    }

    container.register(ProfileSettingUseCaseType.self) { resolver in
      let service = resolver.resolve(ProfileSettingServiceType.self)!
      return ProfileSettingUseCase(service: service)
    }
  }

  // MARK: Initializer
  public init() {}
}
