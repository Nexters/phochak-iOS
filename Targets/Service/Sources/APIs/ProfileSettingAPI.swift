//
//  ProfileSettingAPI.swift
//  Service
//
//  Created by 한상진 on 2023/03/01.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

enum ProfileSettingAPI {
  case checkDuplication(nickName: String)
  case changeNickName(nickName: String)
}

// MARK: - TargetType
extension ProfileSettingAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    switch self {
    case .checkDuplication: return "/v1/user/check/nickname"
    case .changeNickName: return "/v1/user/nickname"
    }
  }

  var method: Moya.Method {
    switch self {
    case .checkDuplication: return .get
    case .changeNickName: return .put
    }
  }

  public var sampleData: Data {
    return .init()
  }

  public var headers: [String : String]? {
    switch self {
    case .checkDuplication: return [:]
    case .changeNickName: return ["Authorization": AppProperties.accessToken]
    }
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
    case .checkDuplication(let nickName):
      return ["nickname": nickName]
    case .changeNickName(let nickName):
      return ["nickname": nickName]
    }
  }
}
