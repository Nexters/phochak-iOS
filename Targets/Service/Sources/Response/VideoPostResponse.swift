//
//  VideoPostResponse.swift
//  Service
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

public struct VideoPostsResponse {

  // MARK: Properties
  let resCode: String
  let resMessage: String

  let posts: [VideoPost]

  enum CodingKeys: String, CodingKey {
    case resCode
    case resMessage
    case posts
  }
}
