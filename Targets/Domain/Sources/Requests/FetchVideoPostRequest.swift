//
//  FetchVideoPostRequest.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct FetchVideoPostRequest {

  // MARK: Properties
  let sortOption: SortOption
  let pageSize: Int

  public init(sortOption: SortOption, pageSize: Int) {
    self.sortOption = sortOption
    self.pageSize = pageSize
  }
}
