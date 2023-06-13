//
//  SearchServiceType.swift
//  Domain
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SearchServiceType: AnyObject {
  func searchVideoPost(request: SearchVideoPostRequest) -> Single<(posts: [VideoPost], isLastPage: Bool)>
  func fetchAutoCompletionKeywordList(keyword: String) -> Single<[String]>
}
