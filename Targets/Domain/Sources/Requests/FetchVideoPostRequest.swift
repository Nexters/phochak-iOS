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
  let lastVideoPostID: Int
  let count: Int

  public init(lastVideoPostID: Int, count: Int = 10) {
    self.lastVideoPostID = lastVideoPostID
    self.count = count
  }
}
