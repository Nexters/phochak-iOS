//
//  TokenUpdateAPI.swift
//  Service
//
//  Created by 한상진 on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

enum TokenUpdateAPI {
  case tryUpdate
}

// MARK: - TargetType
extension TokenUpdateAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    return "/v1/user/reissue-token"
  }

  var method: Moya.Method {
    return .post
  }

  public var sampleData: Data {
    return .init()
  }

  public var headers: [String : String]? {
    return [:]
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
    switch self {
    case .tryUpdate:
      return [
        "accessToken": AppProperties.accessToken,
        "refreshToken": AppProperties.refreshToken
      ]
    }
  }
}
