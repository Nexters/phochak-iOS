//
//  ExclameVideoPostUseCase.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol ExclameVideoPostUseCaseType {

  // MARK: Methods
  func exclameVideoPost(postID: Int) -> Observable<Void>
}

final class ExclameVideoPostUseCase: ExclameVideoPostUseCaseType {

  // MARK: Properties
  private let service: VideoPostServiceType

  // MARK: Initializer
  init(service: VideoPostServiceType) {
    self.service = service
  }

  // MARK: Methods
  func exclameVideoPost(postID: Int) -> Observable<Void> {
    service.exclameVideoPost(postID: postID)
      .asObservable()
  }
}
