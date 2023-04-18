//
//  Reactive+.swift
//  Service
//
//  Created by 한상진 on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import UIKit

import Moya
import RxSwift

public extension Reactive where Base: MoyaProviderType {

  // MARK: Methods
  func request(_ target: Base.Target) -> Single<Response> {
    let requestSingle = Single.create { [weak base] single in
      let cancellableToken = base?.request(target, callbackQueue: nil, progress: nil) { result in
        switch result {
        case let .success(response):
          single(.success(response))
        case let .failure(error):
          single(.failure(error))
        }
      }

      return Disposables.create {
        cancellableToken?.cancel()
      }
    }

    return requestSingle
      .map { response -> (Response, TokenErrorResponse) in
        do {
          let tokenErrorResponse = try response.map(TokenErrorResponse.self)
          return (response, tokenErrorResponse)
        } catch {
          return (response, TokenErrorResponse.init(
            status: .init(code: PhoChakNetworkResult.P000.rawValue, message: ""),
            data: nil)
          )
        }
      }
      .flatMap { (requestResponse, tokenErrorResponse) in
        guard !isValidationToken(tokenErrorResponse) else { return .just(requestResponse) }

        return requestUpdateToken()
          .filter { response in
            do {
              if !isValidationToken(try response.map(TokenErrorResponse.self)) {
                TokenManager.deleteAll()
                UIApplication.presentTokenExpiredAlert()
                return false
              }
            } catch {
              updateToken(try response.map(SignInResponse.self).makeUserToken())
              return true
            }

            return false
          }
          .asObservable()
          .asSingle()
          .flatMap { _ in
            request(target)
          }
      }
  }

  private func requestUpdateToken() -> Single<Response> {
    let provider: MoyaProvider<TokenUpdateAPI> = .init(plugins: [PCNetworkLoggerPlugin()])

    return .create { single in
      let cancellableToken = provider.request(.tryUpdate) { result in
        switch result {
        case let .success(response):
          single(.success(response))
        case let .failure(error):
          single(.failure(error))
        }
      }

      return Disposables.create {
        cancellableToken.cancel()
      }
    }
  }

  private func updateToken(_ userToken: UserToken) {
    guard let accessTokenData = userToken.accessToken.data(using: .utf8),
          let refreshTokenData = userToken.refreshToken.data(using: .utf8)
    else { return }

    TokenManager.save(tokenType: .accessToken, data: accessTokenData)
    TokenManager.save(tokenType: .refreshToken, data: refreshTokenData)
  }

  private func isValidationToken(_ response: TokenErrorResponse) -> Bool {
    guard response.status.code == PhoChakNetworkResult.P203.rawValue
    else { return true }

    return false
  }
}
