//
//  ResponseStatus.swift
//  Service
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct ResponseStatus: Decodable {

  // MARK: Properties
  let code: String
  let message: String

  enum CodingKeys: String, CodingKey {
    case code = "resCode"
    case message = "resMessage"
  }
}
