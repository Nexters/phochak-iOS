//
//  ProfileSettingService.swift
//  Service
//
//  Created by 한상진 on 2023/03/01.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift

final class ProfileSettingService: ProfileSettingServiceType {

  // MARK: Properties
  private let provider: MoyaProvider<ProfileSettingAPI>

  // MARK: Initializer
  init(
    provider: MoyaProvider<ProfileSettingAPI> = MoyaProvider<ProfileSettingAPI>(plugins: [PCNetworkLoggerPlugin()])
  ) {
    self.provider = provider
  }

  // MARK: Methods
  func checkDuplicationNickName(nickName: String) -> Single<Bool> {
    provider.rx.request(.checkDuplication(nickName: nickName))
      .map(CheckDuplicationResponse.self)
      .map { $0.data.isDuplicated }
  }

  func changeNickName(nickName: String) -> Single<Void> {
    provider.rx.request(.changeNickName(nickName: nickName))
      .map(ChangeNickNameResponse.self)
      .flatMap { response -> Single<Void> in
        if response.status.code == PhoChakNetworkResult.P301.rawValue {
          return .error(ProfileSettingResult.error)
        }
        return .just(())
      }
      .map { _ in }
  }
}
