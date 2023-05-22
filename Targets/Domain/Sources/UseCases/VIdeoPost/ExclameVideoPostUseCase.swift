//
//  ExclameVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol ExclameVideoPostUseCaseType {
  var videoPostService: VideoPostServiceType { get }

  func exclameVideoPost(postID: Int) -> Observable<Bool>
}

extension ExclameVideoPostUseCaseType {
  func exclameVideoPost(postID: Int) -> Observable<Bool> {
    videoPostService.exclameVideoPost(postID: postID)
      .asObservable()
  }
}

final class ExclameVideoPostUseCase: ExclameVideoPostUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType

  // MARK: Initializer
  init(videoPostService: VideoPostServiceType) {
    self.videoPostService = videoPostService
  }
}
