//
//  SearchVideoPostRequest.swift
//  Domain
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct SearchVideoPostRequest {

  // MARK: Properties
  public let category: PostCategory?
  public let query: String?
  public let lastID: Int?
  public let pageSize: Int

  public init(category: PostCategory?, query: String?, lastID: Int?, pageSize: Int = 5) {
    self.category = category
    self.query = query
    self.lastID = lastID
    self.pageSize = pageSize
  }
}
