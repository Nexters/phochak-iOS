//
//  VideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol VideoPostUseCaseType:
  FetchVideoPostUseCaseType,
  LikeVideoPostUseCaseType,
  ExclameVideoPostUseCaseType {}

final class VideoPostUseCase: VideoPostUseCaseType {

  // MARK: Properties
  private let service: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.service = service
  }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)> {
    service.fetchVideoPosts(request: request)
      .asObservable()
      .catchAndReturn(([], true))
  }

  func likeVideoPost(postID: Int) -> Observable<Bool> {
    service.likeVideoPost(postID: postID)
      .asObservable()
  }

  func unLikeVideoPost(postID: Int) -> Observable<Bool> {
    service.unlikeVideoPost(postID: postID)
      .asObservable()
  }

  func exclameVideoPost(postID: Int) -> Observable<Void> {
    service.exclameVideoPost(postID: postID)
      .asObservable()
  }
}
