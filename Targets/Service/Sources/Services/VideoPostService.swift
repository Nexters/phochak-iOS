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

    let dummyPosts: [VideoPost] = [.init(
        id: 0,
        user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
        shorts: Shorts(id: 0, shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", thumbnailURLString: "www.google.com"),
        viewCount: 13,
        category: "RESTAURENT",
        likeCount: 13,
        hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
      ),
       .init(
          id: 1,
          user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
          shorts: Shorts(id: 0, shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", thumbnailURLString: "www.google.com"),
          viewCount: 13,
          category: "RESTAURENT",
          likeCount: 13,
          hashTags: ["1가나다라마바사아자카", "2가나다라마바사아자카", "3가나다라마바사아자카", "4가나다라마바사아자카", "5가나다라마바사아자카", "6가나다라마바사아자카", "7가나다라마바사아자카", "8가나다라마바사아자카", "아 졸리다 졸려", "10번째 해시태그", "11가나다라마바사아자", "12가나다라마바사아자카", "13가나다라마바사아자카", "14가나다라마바사아자카"]
       ),
        .init(
          id: 2,
          user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
          shorts: Shorts(id: 0, shortsURLString: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", thumbnailURLString: "www.google.com"),
          viewCount: 13,
          category: "RESTAURENT",
          likeCount: 13,
          hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
        ),
       .init(
         id: 3,
         user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
         shorts: Shorts(id: 0, shortsURLString: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", thumbnailURLString: "www.google.com"),
         viewCount: 13,
         category: "RESTAURENT",
         likeCount: 13,
         hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
       ),
       .init(
         id: 4,
         user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
         shorts: Shorts(id: 0, shortsURLString: "http://cdn-fms.rbs.com.br/vod/hls_sample1_manifest.m3u8", thumbnailURLString: "www.google.com"),
         viewCount: 13,
         category: "RESTAURENT",
         likeCount: 13,
         hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
       ),
       .init(
         id: 5,
         user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
         shorts: Shorts(id: 0, shortsURLString: "http://cdn-fms.rbs.com.br/vod/hls_sample1_manifest.m3u8", thumbnailURLString: "www.google.com"),
         viewCount: 13,
         category: "RESTAURENT",
         likeCount: 13,
         hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
       ),
       .init(
         id: 6,
         user: User(id: 0, nickname: "포착러", profileImageURLString: "www.google.com"),
         shorts: Shorts(id: 0, shortsURLString: "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8", thumbnailURLString: "www.google.com"),
         viewCount: 13,
         category: "RESTAURENT",
         likeCount: 13,
         hashTags: ["가나다", "가나다라마바사아자카파", "동네동네동네동네동네", "동네", "동네동네", "동네동네동네"]
       )
      ]


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
