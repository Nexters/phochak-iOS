//
//  MyPageUseCase.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol MyPageUseCaseType: FetchVideoPostUseCaseType, FetchProfileUseCaseType {
  func signOut() -> Observable<Void>
  func logout() -> Observable<Void>
  func deleteVideoPost(postID: Int) -> Observable<Void>
}

final class MyPageUseCase: MyPageUseCaseType {

  // MARK: Properties
  private let postsService: VideoPostServiceType
  private let profileService: ProfileServiceType
  private let settingService: SettingServiceType

  init(
    postsService: VideoPostServiceType,
    profileService: ProfileServiceType,
    settingService: SettingServiceType
  ) {
    self.postsService = postsService
    self.profileService = profileService
    self.settingService = settingService
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

  func signOut() -> Observable<Void> {
    settingService.signOut().asObservable()
  }

  func logout() -> Observable<Void> {
    settingService.logout().asObservable()
  }

  func deleteVideoPost(postID: Int) -> Observable<Void> {
    postsService.deleteVideoPost(postID: postID).asObservable()
  }
}
