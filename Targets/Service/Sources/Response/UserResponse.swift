//
//  UserResponse.swift
//  Service
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

public struct UserResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  public let user: User

  enum CodingKeys: String, CodingKey {
    case status
    case user = "data"
  }
}
