//
//  ProfileService.swift
//  Service
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift

public final class ProfileService: ProfileServiceType {

  // MARK: Properties
  private let provider: MoyaProvider<ProfileAPI>

  // MARK: Initializer
  init(provider: MoyaProvider<ProfileAPI> = .init(plugins: [PCNetworkLoggerPlugin()])) {
    self.provider = provider
  }

  // MARK: Methods
  public func fetchUserProfile(userID: String) -> Single<User> {
    provider.rx.request(.fetchUserProfile(userID: userID))
      .map(UserResponse.self)
      .map { $0.user }
  }
}
