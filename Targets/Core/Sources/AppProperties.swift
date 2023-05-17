//
//  AppProperties.swift
//  Core
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public enum AppProperties {

  // MARK: Properties
  public static var baseURL: String {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let baseURL = infoDictionary["BASE_URL"] as? String
    else { return .init() }

    return "http://\(baseURL)"
  }

  public static var accessToken: String {
    guard let accessTokenData = AuthManager.load(authInfoType: .accessToken) else { return .init() }

    return String(decoding: accessTokenData, as: UTF8.self)
  }

  public static var refreshToken: String {
    guard let refreshTokenData = AuthManager.load(authInfoType: .refreshToken) else { return .init() }

    return String(decoding: refreshTokenData, as: UTF8.self)
  }
}
