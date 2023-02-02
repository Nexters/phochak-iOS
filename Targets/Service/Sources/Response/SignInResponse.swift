//
//  SignInResponse.swift
//  Service
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import Foundation

public struct SignInResponse: Decodable {

  // MARK: Properties
  let resCode: String
  let resMessage: String
  let data: UserAccountData
}

public struct UserAccountData: Decodable {

  // MARK: Properties
  let accessToken: String
  let accessTokenExpiresIn: String
  let refreshToken: String
  let refreshTokenExpiresIn: String

  enum CodingKeys: String, CodingKey {
    case accessToken, refreshToken, refreshTokenExpiresIn
    case accessTokenExpiresIn = "expiresIn"
  }
}

public extension SignInResponse {
  func makeUserToken() -> UserToken {
    return .init(accessToken: data.accessToken, refreshToken: data.refreshToken)
  }
}
