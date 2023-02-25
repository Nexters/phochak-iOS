//
//  SignInRepositoryType.swift
//  Domain
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SignInServiceType {

  // MARK: Methods
  func tryKakaoSignIn() -> Observable<UserToken>
  func tryAppleSignIn(token: String) -> Observable<UserToken>
}

