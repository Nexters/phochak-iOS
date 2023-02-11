//
//  VideoPostService.swift
//  Service
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift
import RxMoya

final class VideoPostService: VideoPostServiceType {

  // MARK: Properties
  private let provider: MoyaProvider<VideoPostAPI>

  // MARK: Initializer
  init(provider: MoyaProvider<VideoPostAPI> = MoyaProvider<VideoPostAPI>(plugins: [PCNetworkLoggerPlugin()])) {
    self.provider = provider
  }

  // MARK: Methods
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Single<(posts: [VideoPost], isLastPage: Bool)> {
    return provider.rx.request(.fetchVideoPosts(request: request))
      .map(VideoPostsResponse.self)
      .map { ($0.posts, $0.isLastPage) }
  }

  func exclameVideoPost(postID: Int) -> Single<Void> {
    provider.rx.request(.exclameVideoPost(postID: postID))
      .map { _ in }
  }

  func likeVideoPost(postID: Int) -> Single<Void> {
    provider.rx.request(.likeVideoPost(postID: postID))
      .map { _ in }
  }
}
