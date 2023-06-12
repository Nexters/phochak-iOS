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
      return FetchVideoPostUseCase(videoPostService: service)
    }

    container.register(ExclameVideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return ExclameVideoPostUseCase(videoPostService: service)
    }

    container.register(LikeVideoPostUseCase.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return LikeVideoPostUseCase(service: service)
    }

    container.register(VideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(VideoPostServiceType.self)!
      return VideoPostUseCase(videoPostService: service)
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
      return FetchProfileUseCase(profileSerivce: service)
    }

    container.register(MyPageUseCaseType.self) { resolver in
      let postsService = resolver.resolve(VideoPostServiceType.self)!
      let profileService = resolver.resolve(ProfileServiceType.self)!
      let settingService = resolver.resolve(SettingServiceType.self)!
      return MyPageUseCase(videoPostService: postsService, profileService: profileService, settingService: settingService)
    }

    container.register(ProfileSettingUseCaseType.self) { resolver in
      let service = resolver.resolve(ProfileSettingServiceType.self)!
      return ProfileSettingUseCase(service: service)
    }

    container.register(SearchVideoPostUseCaseType.self) { resolver in
      let service = resolver.resolve(SearchServiceType.self)!
      return SearchVideoPostUseCase(searchService: service)
    }

    container.register(FetchSearchAutoCompletionListUseCaseType.self) { resolver in
      let service = resolver.resolve(SearchServiceType.self)!
      return FetchSearchAutoCompletionListUseCase(searchService: service)
    }
  }

  // MARK: Initializer
  public init() {}
}
