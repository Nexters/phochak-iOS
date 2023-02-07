//
//  SortOption.swift
//  Domain
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public enum SortOption {
  case phochak(lastLikeCount: Int, lastPostID: Int)
  case latest(lastPostID: Int?)
  case views(lastViewCount: Int, lastPostID: Int)

  var option: String {
    switch self {
    case .phochak: return "PHOCHAK"
    case .views: return "VIEWS"
    case .latest: return "LATEST"
    }
  }
}
