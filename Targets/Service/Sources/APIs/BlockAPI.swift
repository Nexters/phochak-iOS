//
//  BlockAPI.swift
//  Service
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Foundation
import Domain

import Moya

public enum BlockAPI {
  case blockUser(userID: Int)
  case unBlockUser(userID: Int)
  case fetchBlockedList
}

// MARK: - TargetType
extension BlockAPI: TargetType {
  public var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  public var path: String {
    let basePath: String = "v1/user/ignore"

    switch self {
    case .blockUser(let userID), .unBlockUser(let userID):
      return basePath + "/\(userID)"

    case .fetchBlockedList:
      return basePath
    }
  }

  public var method: Moya.Method {
    switch self {
    case .blockUser:
      return .post

    case .unBlockUser:
      return .delete

    case .fetchBlockedList:
      return .get
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
    return nil
  }
}
