//
//  VideoPostAPI.swift
//  Networking
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation
import Domain

import Moya

public enum VideoPostAPI {
  case fetchVideoPosts(request: FetchVideoPostRequest)
  case exclameVideoPost(postID: Int)
  case likeVideoPost(postID: Int)
}

// MARK: - TargetType
extension VideoPostAPI: TargetType {
  public var baseURL: URL {
    URL(string: "www.naver.com")!
  }

  public var path: String {
    switch self {
    case .fetchVideoPosts:
      return ""

    case .exclameVideoPost(let postID):
      return ""

    case .likeVideoPost(let postID):
      return ""
    }
  }

  public var method: Moya.Method {
    switch self {
    case .fetchVideoPosts:
      return .get

    case .likeVideoPost, .exclameVideoPost:
      return .post
    }
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
    case .fetchVideoPosts:
      return [:]

    case .likeVideoPost:
      return [:]

    case .exclameVideoPost:
      return [:]
    }
  }
}
