//
//  UploadVideoPostAPI.swift
//  Service
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import Foundation

import Moya

enum UploadVideoPostAPI {
  case fetchPresignedURL(fileType: String)
  case uploadToS3(presignedURL: URL, fileURL: URL)
  case uploadVideoPost(category: String, uploadKey: String, hashTags: [String])
}

// MARK: - TargetType
extension UploadVideoPostAPI: TargetType {
  var baseURL: URL {
    switch self {
    case .uploadToS3(let presignedURL, _): return presignedURL
    default: return URL(string: AppProperties.baseURL)!
    }
  }

  var path: String {
    let basePath: String = "/v1/post"

    switch self {
    case .fetchPresignedURL: return basePath + "/upload-key"
    case .uploadToS3: return ""
    case .uploadVideoPost: return basePath
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchPresignedURL: return .get
    case .uploadToS3: return .put
    case .uploadVideoPost: return .post
    }
  }

  var sampleData: Data {
    return .init()
  }

  var headers: [String : String]? {
    switch self {
    case .uploadToS3: return nil
    default: return ["Authorization": AppProperties.accessToken]
    }
  }

  var task: Task {
    switch self {
    case .uploadToS3(_, let fileURL): return .uploadFile(fileURL)
    default: break
    }

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
    case .fetchPresignedURL(let fileType): return ["file-extension": fileType]
    case .uploadToS3: return nil
    case .uploadVideoPost(let category, let uploadKey, let hashTags):
      return [
        "category": category,
        "uploadKey": uploadKey,
        "hashtags": hashTags
      ]
    }
  }
}
