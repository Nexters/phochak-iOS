//
//  BlockedListResponse.swift
//  Service
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

public struct BlockedListResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  public let users: [User]

  enum CodingKeys: String, CodingKey {
    case status
    case users = "data"
  }
}
