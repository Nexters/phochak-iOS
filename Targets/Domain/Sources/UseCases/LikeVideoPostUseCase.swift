//
//  LikeVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol LikeVideoPostUseCaseType {

  // MARK: Methods
  func likeVideoPost(postID: Int) -> Observable<Void>
}

final class LikeVideoPostUseCase: LikeVideoPostUseCaseType {

  // MARK: Properties
  private let service: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.service = service
  }

  // MARK: Methods
  func likeVideoPost(postID: Int) -> Observable<Void> {
    service.likeVideoPost(postID: postID)
      .asObservable()
  }
}
