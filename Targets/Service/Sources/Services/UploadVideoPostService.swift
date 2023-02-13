//
//  UploadVideoPostService.swift
//  Service
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya
import RxMoya
import RxSwift


public final class UploadVideoPostService: UploadVideoPostServiceType {

  // MARK: - Properties
  private let provider: MoyaProvider<UploadVideoPostAPI>

  // MARK: Initializer
  init(
    provider: MoyaProvider<UploadVideoPostAPI> = .init(plugins: [NetworkLoggerPlugin()])
  ) {
    self.provider = provider
  }

  // MARK: - Methods
  public func uploadVideoPost(
    videoFile: VideoFile,
    category: String,
    hashTags: [String]
  ) -> Single<Void> {
    fetchPresignedURL(fileType: videoFile.fileType)
      .flatMap { [weak self] response -> Single<String> in
        guard let presignedURL: URL = .init(string: response.uploadData.uploadURL),
              let videoFileURL: URL = .init(
                string: PhoChakFileManager.shared.fetchVideoURLString(name: videoFile.fileName)
              )
        else { return .just("") }

        return self?.uploadToS3(to: presignedURL, with: videoFileURL)
          .map { _ in response.uploadData.uploadKey } ?? .just("")
      }
      .flatMap { [weak self] uploadKey in
        self?.uploadPost(category: category, uploadKey: uploadKey, hashTags: hashTags) ?? .just(())
      }
  }
}

// MARK: - Private
private extension UploadVideoPostService {

  // MARK: Methods
  func fetchPresignedURL(fileType: String) -> Single<FetchPresignedURLResponse> {
    provider.rx.request(.fetchPresignedURL(fileType: fileType))
      .map(FetchPresignedURLResponse.self)
  }

  func uploadToS3(to presignedURL: URL, with fileURL: URL) ->  Single<Response> {
    provider.rx.request(.uploadToS3(presignedURL: presignedURL, fileURL: fileURL))
  }

  func uploadPost(category: String, uploadKey: String, hashTags: [String]) -> Single<Void> {
    provider.rx.request(.uploadVideoPost(
      category: category,
      uploadKey: uploadKey,
      hashTags: hashTags
    ))
    .map(UploadVideoPostResponse.self)
    .map { _ in }
  }
}
