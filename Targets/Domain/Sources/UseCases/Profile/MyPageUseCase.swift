//
//  MyPageUseCase.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public typealias MyPageUseCaseType = FetchVideoPostUseCaseType & FetchProfileUseCaseType & DeleteVideoPostUseCaseType & SignOutUseCaseType & LogoutUseCaseType

final class MyPageUseCase: MyPageUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType
  let profileService: ProfileServiceType
  let settingService: SettingServiceType

  init(
    videoPostService: VideoPostServiceType,
    profileService: ProfileServiceType,
    settingService: SettingServiceType
  ) {
    self.videoPostService = videoPostService
    self.profileService = profileService
    self.settingService = settingService
  }
}
