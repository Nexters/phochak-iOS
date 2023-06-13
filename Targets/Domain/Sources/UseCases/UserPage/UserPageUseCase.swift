//
//  UserPageUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/06/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public typealias UserPageUseCaseType = FetchVideoPostUseCaseType & BlockUseCaseType

final class UserPageUseCase: UserPageUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType
  let blockService: BlockServiceType

  init(
    videoPostService: VideoPostServiceType,
    blockService: BlockServiceType
  ) {
    self.videoPostService = videoPostService
    self.blockService = blockService
  }
}
