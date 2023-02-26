//
//  MyPageUseCase.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol MyPageUseCaseType: FetchVideoPostUseCaseType, FetchProfileUseCaseType {}

final class MyPageUseCase: MyPageUseCaseType {

  // MARK: Properties
  private let postsService: VideoPostServiceType
  private let profileService: ProfileServiceType

  init(postsService: VideoPostServiceType, profileService: ProfileServiceType) {
    self.postsService = postsService
    self.profileService = profileService
  }

  func fetchVideoPosts(request: FetchVideoPostRequest) -> Observable<(posts: [VideoPost], isLastPage: Bool)> {
    postsService.fetchVideoPosts(request: request)
      .asObservable()
      .catchAndReturn(([], true))
  }

  func fetchUserProfile(userID: String) -> Observable<User> {
    profileService.fetchUserProfile(userID: userID)
      .asObservable()
  }
}
