//
//  UploadVideoPostUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

import RxSwift

public enum UploadVideoPostResult: Error {
  case success
  case error
}

public protocol UploadVideoPostUseCaseType {

  // MARK: Properties
  var uploadVideoPostResultSubject: PublishSubject<UploadVideoPostResult> { get }

  // MARK: Methods
  func uploadVideoPost(
    videoFile: VideoFile,
    category: String,
    hashTags: [String]
  ) -> Observable<Void>
}

final class UploadVideoPostUseCase: UploadVideoPostUseCaseType {

  // MARK: Properties
  public let uploadVideoPostResultSubject: PublishSubject<UploadVideoPostResult> = .init()
  private let service: UploadVideoPostServiceType
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  init(service: UploadVideoPostServiceType) {
    self.service = service
  }

  // MARK: Methods
  func uploadVideoPost(
    videoFile: VideoFile,
    category: String,
    hashTags: [String]
  ) -> Observable<Void> {
    service.uploadVideoPost(
      videoFile: videoFile,
      category: category,
      hashTags: hashTags
    )
    .subscribe(with: self, onSuccess: { owner, _ in
      owner.uploadVideoPostResultSubject.onNext(.success)
    }, onFailure: { owner, error in
      owner.uploadVideoPostResultSubject.onNext(.error)
    })
    .disposed(by: disposeBag)

    return .just(())
  }
}
