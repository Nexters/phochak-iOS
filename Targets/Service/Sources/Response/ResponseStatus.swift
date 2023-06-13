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

extension ResponseStatus {
  var isSuccess: Bool {
    code == PhoChakNetworkResult.P000.rawValue
  }
}

public struct BaseResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  let data: String?

  enum CodingKeys: String, CodingKey {
    case status
    case data
  }
}

extension BaseResponse {
  var isSuccess: Bool {
    status.code == PhoChakNetworkResult.P000.rawValue
  }
}

public struct StringArrayResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  let data: [String]

  enum CodingKeys: String, CodingKey {
    case status
    case data
  }
}
