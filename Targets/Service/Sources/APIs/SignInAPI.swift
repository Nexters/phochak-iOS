//
//  SignInAPI.swift
//  Service
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

enum SignInAPI {
  case tryKakaoSignIn(accessToken: String)
}

// MARK: - TargetType
extension SignInAPI: TargetType {
  var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  var path: String {
    let basePath = "/v1/user/login"

    switch self {
    case .tryKakaoSignIn:
      return basePath + "/kakao"
    }
  }

  var method: Moya.Method {
    return .get
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
    case .tryKakaoSignIn(let oAuthToken):
      return ["token": oAuthToken]
    }
  }
}
