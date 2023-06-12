//
//  SearchVideoPostUseCase.swift
//  Domain
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SearchVideoPostUseCaseType: AnyObject {
  func execute(request: SearchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)>
}

final class SearchVideoPostUseCase: SearchVideoPostUseCaseType {

  // MARK: Properties
  private let searchService: SearchServiceType

  // MARK: Initializer
  init(searchService: SearchServiceType) {
    self.searchService = searchService
  }

  // MARK: Methods
  func execute(request: SearchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)> {
    searchService.searchVideoPost(request: request)
      .asObservable()
  }
}
