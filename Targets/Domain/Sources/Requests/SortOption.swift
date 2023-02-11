//
//  SortOption.swift
//  Domain
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public enum SortOption: Equatable {
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
