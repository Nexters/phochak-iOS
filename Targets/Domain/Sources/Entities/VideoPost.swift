//
//  VideoPost.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct VideoPost: Equatable {

  // MARK: Properties
  let postID: Int
  public let hashTags: [String]?
  public let postCategory: String
  public let viewCount: Int
//  public let user: User
  public let shorts: Shorts

  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case hashTags = "HashTags"
    case viewCount = "view"
    case postCategory
    case shorts
  }

  public static func == (lhs: VideoPost, rhs: VideoPost) -> Bool {
    lhs.postID == rhs.postID
  }

  public init(postID: Int, hashTags: [String]?, postCategory: String, viewCount: Int, shorts: Shorts) {
    self.postID = postID
    self.hashTags = hashTags
    self.postCategory = postCategory
    self.viewCount = viewCount
    self.shorts = shorts
  }
}
