//
//  UploadVideoPostUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

import RxSwift

public enum UploadVideoPostEvent {
  case success
  case error
}

public protocol UploadVideoPostUseCaseType {

  // MARK: Properties
  var uploadVideoPostEvent: PublishSubject<UploadVideoPostEvent> { get }

  // MARK: Methods
  func uploadVideoPost(
    videoURLString: String,
    videoType: String,
    category: String,
    hashTags: [String]
  ) -> Observable<Void>
}

final class UploadVideoPostUseCase: UploadVideoPostUseCaseType {

  // MARK: Properties
  public let uploadVideoPostEvent: PublishSubject<UploadVideoPostEvent> = .init()
  private let service: UploadVideoPostServiceType
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  init(service: UploadVideoPostServiceType) {
    self.service = service
  }

  // MARK: Methods
  func uploadVideoPost(
    videoURLString: String,
    videoType: String,
    category: String,
    hashTags: [String]
  ) -> Observable<Void> {
    guard let videoURL = URL(string: videoURLString) else { return .just(()) }
    
    service.uploadVideoPost(
      videoURL: videoURL,
      videoType: videoType,
      category: category,
      hashTags: hashTags
    )
    .subscribe(with: self, onSuccess: { owner, _ in
      owner.uploadVideoPostEvent.onNext(.success)
    }, onFailure: { owner, error in
      owner.uploadVideoPostEvent.onNext(.error)
    })
    .disposed(by: disposeBag)

    return .just(())
  }
}
