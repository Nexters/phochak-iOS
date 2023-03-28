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
  func deleteVideoPost(postID: Int) -> Single<Void>


  /// 포스트 좋아요를 요청합니다.
  /// - Parameter postID
  /// - Returns: 성공의 경우 true, 실패의 경우 false를 반환합니다.
  func likeVideoPost(postID: Int) -> Single<Bool>

  /// 포스트 좋아요를 해제합니다.
  /// - Parameter postID
  /// - Returns: 성공의 경우 true, 실패의 경우 false를 반환합니다.
  func unlikeVideoPost(postID: Int) -> Single<Bool>
}
