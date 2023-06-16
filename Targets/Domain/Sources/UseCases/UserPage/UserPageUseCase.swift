//
//  UserPageUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/06/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public typealias UserPageUseCaseType = FetchVideoPostUseCaseType & BlockUseCaseType & FetchProfileUseCaseType

final class UserPageUseCase: UserPageUseCaseType {

  // MARK: Properties
  let profileService: ProfileServiceType
  let videoPostService: VideoPostServiceType
  let blockService: BlockServiceType

  init(
    profileService: ProfileServiceType,
    videoPostService: VideoPostServiceType,
    blockService: BlockServiceType
  ) {
    self.profileService = profileService
    self.videoPostService = videoPostService
    self.blockService = blockService
  }
}
