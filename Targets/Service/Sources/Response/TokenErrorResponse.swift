//
//  TokenErrorResponse.swift
//  Service
//
//  Created by 한상진 on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct TokenErrorResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  let data: String?
}
