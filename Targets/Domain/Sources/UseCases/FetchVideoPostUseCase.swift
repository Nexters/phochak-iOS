//
//  FetchVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol FetchVideoPostUseCaseType {

  // MARK: Methods
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<[VideoPost]>
}

final class FetchVideoPostUseCase: FetchVideoPostUseCaseType {

  // MARK: Properties
  private let service: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.service = service
  }

  // MARK: Methods
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<[VideoPost]> {
    return service.fetchVideoPosts(request: request)
      .asObservable()
      .catchAndReturn([])
  }
}
