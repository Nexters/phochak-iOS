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
  public let targetUserID: Int?

  // MARK: Initializer
  public init(
    sortOption: PostsSortOption,
    lastID: Int? = nil,
    pageSize: Int = 5,
    filterOption: PostsFilterOption? = nil,
    targetUserID: Int? = nil
  ) {
    self.sortOption = sortOption
    self.lastID = lastID
    self.pageSize = pageSize
    self.filterOption = filterOption
    self.targetUserID = targetUserID
  }

  // MARK: Methods
  public static func == (lhs: FetchVideoPostRequest, rhs: FetchVideoPostRequest) -> Bool {
    if lhs.sortOption == rhs.sortOption {
      return lhs.pageSize == rhs.pageSize && lhs.lastID == rhs.lastID
    }

    return false
  }
}
