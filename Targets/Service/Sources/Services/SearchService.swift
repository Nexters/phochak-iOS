//
//  SearchService.swift
//  Service
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift

final class SearchService: SearchServiceType {

  // MARK: Properties
  private let networkProvider: MoyaProvider<SearchAPI>

  // MARK: Initializer
  init(networkProvider: MoyaProvider<SearchAPI> = MoyaProvider<SearchAPI>(plugins: [PCNetworkLoggerPlugin()])) {
    self.networkProvider = networkProvider
  }

  func searchVideoPost(request: SearchVideoPostRequest) -> Single<(posts: [VideoPost], isLastPage: Bool)> {
    networkProvider.rx.request(.searchVideoPost(request: request))
      .map(VideoPostsResponse.self)
      .map { ($0.posts, $0.isLastPage) }
  }

  func fetchAutoCompletionKeywordList(keyword: String) -> Single<[String]> {
    networkProvider.rx.request(.fetchAutoCompletionKeywordList(keyword: keyword))
      .map(StringArrayResponse.self)
      .map { $0.data }
  }
}
