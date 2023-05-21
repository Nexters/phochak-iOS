//
//  VideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public typealias VideoPostUseCaseType = FetchVideoPostUseCaseType & LikeVideoPostUseCaseType & ExclameVideoPostUseCaseType

final class VideoPostUseCase: VideoPostUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType

  // MARK: Initializer
  init(videoPostService: VideoPostServiceType) {
    self.videoPostService = videoPostService
  }
}
