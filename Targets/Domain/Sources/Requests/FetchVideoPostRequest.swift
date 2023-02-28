//
//  FetchVideoPostRequest.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct FetchVideoPostRequest: Equatable {

  // MARK: Properties
  public let sortOption: PostsSortOption
  public let lastID: Int?
  public let pageSize: Int
  public let filterOption: PostsFilterOption?

  // MARK: Initializer
  public init(sortOption: PostsSortOption, lastID: Int? = nil, pageSize: Int = 5, filterOption: PostsFilterOption? = nil) {
    self.sortOption = sortOption
    self.lastID = lastID
    self.pageSize = pageSize
    self.filterOption = filterOption
  }

  // MARK: Methods
  public static func == (lhs: FetchVideoPostRequest, rhs: FetchVideoPostRequest) -> Bool {
    if lhs.sortOption == rhs.sortOption {
      return lhs.pageSize == rhs.pageSize && lhs.lastID == rhs.lastID
    }

    return false
  }
}
