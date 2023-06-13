//
//  FetchSearchAutoCompletionListUseCase.swift
//  Service
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol FetchSearchAutoCompletionListUseCaseType: AnyObject {
  func execute(_ query: String) -> Observable<[String]>
}

final class FetchSearchAutoCompletionListUseCase: FetchSearchAutoCompletionListUseCaseType {

  // MARK: Properties
  private let searchService: SearchServiceType

  // MARK: Initializer
  init(searchService: SearchServiceType) {
    self.searchService = searchService
  }

  // MARK: Methods
  func execute(_ query: String) -> Observable<[String]> {
    searchService.fetchAutoCompletionKeywordList(keyword: query)
      .asObservable()
  }
}
