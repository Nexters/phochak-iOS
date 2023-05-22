//
//  LogoutUseCase.swift
//  Domain
//
//  Created by 여정수 on 2023/05/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol LogoutUseCaseType {
  var settingService: SettingServiceType { get }

  func logout() -> Observable<Void>
}

extension LogoutUseCaseType {
  func logout() -> Observable<Void> {
    settingService.logout()
      .asObservable()
  }
}

final class LogoutUseCase: LogoutUseCaseType {

  // MARK: Properties
  let settingService: SettingServiceType

  init(settingService: SettingServiceType) {
    self.settingService = settingService
  }
}
