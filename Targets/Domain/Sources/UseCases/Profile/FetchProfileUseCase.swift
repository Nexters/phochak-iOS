//
//  FetchProfileUseCase.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol FetchProfileUseCaseType {
  var profileService: ProfileServiceType { get }

  func fetchUserProfile(userID: String) -> Observable<User>
}

extension FetchProfileUseCaseType {
  func fetchUserProfile(userID: String) -> Observable<User> {
    profileService.fetchUserProfile(userID: userID)
      .asObservable()
  }
}

final class FetchProfileUseCase: FetchProfileUseCaseType {

  // MARK: Properties
  let profileService: ProfileServiceType

  // MARK: Initializer
  init(profileSerivce: ProfileServiceType) {
    self.profileService = profileSerivce
  }
}

