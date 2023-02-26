//
//  PostsSortOption.swift
//  Domain
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public enum PostsSortOption: Equatable {
  case like(lastLikeCount: Int)
  case view(lastViewCount: Int)
  case latest

  public var option: String {
    switch self {
    case .like: return "LIKE"
    case .view: return "VIEW"
    case .latest: return "LATEST"
    }
  }
}

public enum PostsFilterOption: Equatable {
  case liked
  case uploaded

  public var option: String {
    switch self {
    case .liked: return "LIKED"
    case .uploaded: return "UPLOADED"
    }
  }
}
