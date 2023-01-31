//
//  HomeUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol HomeUseCaseType:
  FetchVideoPostUseCaseType,
  LikeVideoPostUseCaseType,
  ExclameVideoPostUseCaseType {}

final class HomeUseCase: HomeUseCaseType {

  // MARK: Properties
  private let service: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.service = service
  }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<[VideoPost]> {
    service.fetchVideoPosts(request: request)
      .asObservable()
      .catchAndReturn([])
  }

  func likeVideoPost(postID: Int) -> Observable<Void> {
    service.likeVideoPost(postID: postID)
      .asObservable()
  }

  func exclameVideoPost(postID: Int) -> Observable<Void> {
    service.exclameVideoPost(postID: postID)
      .asObservable()
  }
}
