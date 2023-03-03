//
//  SettingAPI.swift
//  Service
//
//  Created by 한상진 on 2023/03/02.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

enum SettingAPI {
  case withdrawl
  case signOut
}

// MARK: - TargetType
extension SettingAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    switch self {
    case .withdrawl: return "/v1/user/withdraw"
    case .signOut: return "/v1/user/logout"
    }
  }

  var method: Moya.Method {
    switch self {
    case .withdrawl: return .post
    case .signOut: return .post
    }
  }

  public var sampleData: Data {
    return .init()
  }

  public var headers: [String : String]? {
    return ["Authorization": AppProperties.accessToken]
  }

  public var task: Task {
    let requestParam: [String: Any] = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put, .delete:
      encoding = JSONEncoding.default

    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParam, encoding: encoding)
  }

  private var parameters: [String: Any]? {
    return ["refreshToken": AppProperties.refreshToken]
  }
}
