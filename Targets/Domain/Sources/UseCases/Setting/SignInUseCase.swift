//
//  SignInUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SignInUseCaseType {
  var signinService: SignInServiceType { get }

  func tryKakaoSignIn() -> Observable<UserToken>
  func tryAppleSignIn(token: String) -> Observable<UserToken>
}

extension SignInUseCaseType {
  func tryKakaoSignIn() -> Observable<UserToken> {
    signinService.tryKakaoSignIn()
  }

  func tryAppleSignIn(token: String) -> Observable<UserToken> {
    signinService.tryAppleSignIn(token: token)
  }
}

final class SignInUseCase: SignInUseCaseType {

  // MARK: - Properties
  let signinService: SignInServiceType

  // MARK: - Initializer
  init(service: SignInServiceType) {
    self.signinService = service
  }
}
