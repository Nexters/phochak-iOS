//
//  SearchAPI.swift
//  Service
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Foundation
import Domain

import Moya

public enum SearchAPI {
  case searchVideoPost(request: SearchVideoPostRequest)
  case fetchAutoCompletionKeywordList(keyword: String)
}

// MARK: - TargetType
extension SearchAPI: TargetType {
  public var baseURL: URL {
    URL(string: AppProperties.baseURL)!
  }

  public var path: String {
    switch self{
    case .searchVideoPost:
      return "/v1/post/list/search"
    case .fetchAutoCompletionKeywordList:
      return "/v1/post/hashtag/autocomplete"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .fetchAutoCompletionKeywordList, .searchVideoPost:
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

    case .searchVideoPost(let request):
      var params: [String: Any] = [
        "pageSize": "\(request.pageSize)"
      ]
      if let lastID = request.lastID {
        params["lastID"] = "\(lastID)"
      }
      if let category = request.category {
        params["category"] = category.uppercasedString
      }
      if let query = request.query {
        params["hashtag"] = query
      }

      return params

    case .fetchAutoCompletionKeywordList(let keyword):
      return [
        "hashtag": keyword,
        "resultSize": 15
      ]
    }
  }
}
