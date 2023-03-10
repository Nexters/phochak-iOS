//
//  UserToken.swift
//  Domain
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct UserToken {

  // MARK: Properties
  public let accessToken: String
  public let refreshToken: String


  // MARK: Initializer
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
