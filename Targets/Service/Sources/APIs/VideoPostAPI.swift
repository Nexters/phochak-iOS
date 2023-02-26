//
//  VideoPostAPI.swift
//  Networking
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Foundation
import Domain

import Moya

public enum VideoPostAPI {
  case fetchVideoPosts(request: FetchVideoPostRequest)
  case exclameVideoPost(postID: Int)
  case likeVideoPost(postID: Int)
  case unlikeVideoPost(postID: Int)
}

// MARK: - TargetType
extension VideoPostAPI: TargetType {
  public var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  public var path: String {
    switch self {
    case .fetchVideoPosts:
      return "/v1/post/list"

    case .exclameVideoPost(let postID):
      return ""

    case .likeVideoPost(let postID), .unlikeVideoPost(let postID):
      return "/v1/post/\(postID)/likes"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .fetchVideoPosts:
      return .get

    case .likeVideoPost, .exclameVideoPost:
      return .post

    case .unlikeVideoPost:
      return .delete
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
    case .fetchVideoPosts(let request):

      var params: [String: Any] = [
        "sortOption": request.sortOption.option,
        "pageSize": "\(request.pageSize)"
      ]

      if let lastID = request.lastID {
        params["lastId"] = "\(lastID)"
      }

      if let filterOption = request.filterOption {
        params["filter"] = "\(filterOption.option)"
      }

      return params

    case .likeVideoPost, .unlikeVideoPost:
      return [:]

    case .exclameVideoPost:
      return [:]
    }
  }
}
