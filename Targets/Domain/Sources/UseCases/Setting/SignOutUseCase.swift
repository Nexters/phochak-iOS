//
//  SignOutUseCase.swift
//  Domain
//
//  Created by 여정수 on 2023/05/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SignOutUseCaseType {
  var settingService: SettingServiceType { get }

  func signOut() -> Observable<Void>
}

extension SignOutUseCaseType {
  func signOut() -> Observable<Void> {
    settingService.signOut()
      .asObservable()
  }
}
