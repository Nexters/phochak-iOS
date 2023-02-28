//
//  FetchProfileUseCase.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol FetchProfileUseCaseType {

  // MARK: Methods

  /// 유저의 정보를 조회합니다.
  /// - Parameter userID: 빈 값일 경우 본인의 정보를 조회합니다.
  func fetchUserProfile(userID: String) -> Observable<User>
}

final class FetchProfileUseCase: FetchProfileUseCaseType {

  // MARK: Properties
  private let service: ProfileServiceType

  // MARK: Initializer
  init(service: ProfileServiceType) {
    self.service = service
  }

  // MARK: Methods
  func fetchUserProfile(userID: String) -> Observable<User> {
    service.fetchUserProfile(userID: userID)
      .asObservable()
  }
}
