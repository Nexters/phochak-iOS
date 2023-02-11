//
//  VideoPostServiceType.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol VideoPostServiceType {

  // MARK: Methods
  func fetchVideoPosts(request: FetchVideoPostRequest) -> Single<(posts: [VideoPost], isLastPage: Bool)>
  func exclameVideoPost(postID: Int) -> Single<Void>
  func likeVideoPost(postID: Int) -> Single<Void>
}
