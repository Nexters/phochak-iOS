//
//  FetchVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol FetchVideoPostUseCaseType {
  var videoPostService: VideoPostServiceType { get }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)>
}

extension FetchVideoPostUseCaseType {
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)> {
    videoPostService.fetchVideoPosts(request: request)
      .asObservable()
      .catchAndReturn(([], true))
  }
}

final class FetchVideoPostUseCase: FetchVideoPostUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType

  // MARK: Initializer
  init(videoPostService: VideoPostServiceType) {
    self.videoPostService = videoPostService
  }
}
