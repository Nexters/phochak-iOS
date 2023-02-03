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
  init(provider: MoyaProvider<VideoPostAPI> = MoyaProvider<VideoPostAPI>(plugins: [NetworkLoggerPlugin()])) {
    self.provider = provider
  }

  // MARK: Methods
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Single<[VideoPost]> {
    // TODO: API 나오면 연동
//    provider.rx.request(.fetchVideoPosts(request: request))

    let dummyPosts: [VideoPost] = .init([
      .init(
        postID: 0,
        hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"],
        postCategory: "TEST",
        viewCount: 123,
        shorts: .init(
          id: 0,
          shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
          thumbnailURLString: "TEST")
      ),
      .init(
        postID: 1,
        hashTags: ["1가나다라마바사아자카", "2가나다라마바사아자카", "3가나다라마바사아자카", "4가나다라마바사아자카", "5가나다라마바사아자카", "6가나다라마바사아자카", "7가나다라마바사아자카", "8가나다라마바사아자카", "아 졸리다 졸려", "10번째 해시태그"],
        postCategory: "TEST",
        viewCount: 123,
        shorts: .init(
          id: 0,
          shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
          thumbnailURLString: "TEST")
      ),
      .init(
        postID: 2,
        hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"],
        postCategory: "TEST",
        viewCount: 123,
        shorts: .init(
          id: 0,
          shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
          thumbnailURLString: "TEST")
      ),
      .init(
        postID: 3,
        hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"],
        postCategory: "TEST",
        viewCount: 123,
        shorts: .init(
          id: 0,
          shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
          thumbnailURLString: "TEST")
      ),
      .init(
        postID: 4,
        hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"],
        postCategory: "TEST",
        viewCount: 123,
        shorts: .init(
          id: 0,
          shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8",
          thumbnailURLString: "TEST")
      )
    ])


    return .just(dummyPosts)
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
