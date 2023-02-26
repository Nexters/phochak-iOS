//
//  SignInService.swift
//  Service
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxMoya
import RxKakaoSDKUser
import RxSwift
import KakaoSDKUser

public final class SignInService: SignInServiceType {

  // MARK: - Properties
  private let provider: MoyaProvider<SignInAPI>

  // MARK: Initializer
  init(
    provider: MoyaProvider<SignInAPI> = MoyaProvider<SignInAPI>(plugins: [PCNetworkLoggerPlugin()])
  ) {
    self.provider = provider
  }

  // MARK: - Methods
  public func tryKakaoSignIn() -> Observable<UserToken> {
    let isInstalledKakaoTalk: Bool = UserApi.isKakaoTalkLoginAvailable()

    if isInstalledKakaoTalk {
      return UserApi.shared.rx.loginWithKakaoTalk()
        .withUnretained(self)
        .flatMap { owner, oAuthToken in
          owner.requestKakaoSignIn(accessToken: oAuthToken.accessToken)
        }
    } else {
      return UserApi.shared.rx.loginWithKakaoAccount()
        .withUnretained(self)
        .flatMap { owner, oAuthToken in
          owner.requestKakaoSignIn(accessToken: oAuthToken.accessToken)
        }
    }
  }

  public func tryAppleSignIn(token: String) -> Observable<UserToken> {
    requestAppleSignIn(token: token)
      .asObservable()
  }
}

// MARK: - Extension
private extension SignInService {
  func requestKakaoSignIn(accessToken: String) -> Single<UserToken> {
    provider.rx.request(.tryKakaoSignIn(accessToken: accessToken))
      .map(SignInResponse.self)
      .map { $0.makeUserToken() }
  }

  func requestAppleSignIn(token: String) -> Single<UserToken> {
    provider.rx.request(.tryAppleSignIn(token: token))
      .map(SignInResponse.self)
      .map { $0.makeUserToken() }
  }
}
