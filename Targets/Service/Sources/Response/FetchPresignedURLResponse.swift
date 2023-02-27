//
//  FetchPresignedURLResponse.swift
//  Service
//
//  Created by 한상진 on 2023/02/09.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct FetchPresignedURLResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  let uploadData: UploadData?

  enum CodingKeys: String, CodingKey {
    case status
    case uploadData = "data"
  }
}

public struct UploadData: Decodable {

  // MARK: Properties
  let uploadURL: String
  let uploadKey: String

  enum CodingKeys: String, CodingKey {
    case uploadURL = "uploadUrl"
    case uploadKey
  }
}
