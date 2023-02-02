//
//  SignInUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol SignInUseCaseType {
  
  // MARK: Methods
  func tryKakaoSignIn() -> Observable<UserToken>
}

public final class SignInUseCase: SignInUseCaseType {

  // MARK: - Properties
  public var signInService: SignInServiceType

  // MARK: - Initializer
  public init(service: SignInServiceType) {
    signInService = service
  }

  // MARK: - Methods
  public func tryKakaoSignIn() -> Observable<UserToken> {
    signInService.tryKakaoSignIn()
  }
}
