//
//  LikeVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol LikeVideoPostUseCaseType {
  var videoPostService: VideoPostServiceType { get }
  
  func likeVideoPost(postID: Int) -> Observable<Bool>
  func unLikeVideoPost(postID: Int) -> Observable<Bool>
}

extension LikeVideoPostUseCaseType {
  func likeVideoPost(postID: Int) -> Observable<Bool> {
    videoPostService.likeVideoPost(postID: postID)
      .asObservable()
  }

  func unLikeVideoPost(postID: Int) -> Observable<Bool> {
    videoPostService.unlikeVideoPost(postID: postID)
      .asObservable()
  }
}

final class LikeVideoPostUseCase: LikeVideoPostUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.videoPostService = service
  }
}
