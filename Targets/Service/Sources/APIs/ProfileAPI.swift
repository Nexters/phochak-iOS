//
//  ProfileAPI.swift
//  Service
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

public enum ProfileAPI {
  case fetchUserProfile(userID: String)
}

// MARK: TargetType
extension ProfileAPI: TargetType {
  public var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  public var path: String {
    switch self {
    case .fetchUserProfile(let userID):
      return "/v1/user/\(userID)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .fetchUserProfile:
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
    switch self {
    case .fetchUserProfile(let userID):
      return ["userId": userID]
    }
  }
}
