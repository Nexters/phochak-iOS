//
//  SettingService.swift
//  Service
//
//  Created by 한상진 on 2023/03/02.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift
import RxMoya

final class SettingService: SettingServiceType {

  // MARK: Properties
  private let provider: MoyaProvider<SettingAPI>

  // MARK: Initializer
  init(provider: MoyaProvider<SettingAPI> = MoyaProvider<SettingAPI>(plugins: [PCNetworkLoggerPlugin()])) {
    self.provider = provider
  }

  // MARK: Methods
  func signOut() -> Single<Void> {
    provider.rx.request(.withdrawl)
      .map { _ in }
  }

  func logout() -> Single<Void> {
    provider.rx.request(.signOut)
      .map { _ in }
  }
}
