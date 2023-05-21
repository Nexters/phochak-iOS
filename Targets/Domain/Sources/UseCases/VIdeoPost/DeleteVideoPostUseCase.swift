//
//  DeleteVideoPostUseCase.swift
//  Domain
//
//  Created by 여정수 on 2023/05/21.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol DeleteVideoPostUseCaseType {
  var videoPostService: VideoPostServiceType { get }

  func deleteVideoPost(postID: Int) -> Observable<Void>
}

extension DeleteVideoPostUseCaseType {
  func deleteVideoPost(postID: Int) -> Observable<Void> {
    videoPostService.deleteVideoPost(postID: postID)
      .asObservable()
  }
}

final class DeleteVideoPostUseCase: DeleteVideoPostUseCaseType {

  // MARK: Properties
  let videoPostService: VideoPostServiceType

  // MARK: Initializer
  init(videoPostService: VideoPostServiceType) {
    self.videoPostService = videoPostService
  }
}
