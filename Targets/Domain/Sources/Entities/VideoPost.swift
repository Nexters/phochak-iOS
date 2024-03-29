//
//  VideoPost.swift
//  Domain
//
//  Created by Ian on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct VideoPost: Hashable, Decodable {

  // MARK: Properties
  public let id: Int
  public let user: User
  public let shorts: Shorts
  public let viewCount: Int
  public let category: String
  public let likeCount: Int
  public let hashTags: [String]?
  public var isLiked: Bool
  public let isBlind: Bool

  private enum CodingKeys: String, CodingKey {
    case id
    case user
    case shorts
    case category
    case isLiked
    case isBlind
    case viewCount = "view"
    case likeCount = "like"
    case hashTags = "hashtags"
  }

  public static func == (lhs: VideoPost, rhs: VideoPost) -> Bool {
    lhs.id == rhs.id && lhs.isLiked == rhs.isLiked
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  // MARK: Initializer
  public init(
    id: Int,
    user: User,
    shorts: Shorts,
    viewCount: Int,
    category: String,
    likeCount: Int,
    hashTags: [String]? = nil,
    isLiked: Bool,
    isBlind: Bool
  ) {
    self.id = id
    self.user = user
    self.shorts = shorts
    self.viewCount = viewCount
    self.category = category
    self.likeCount = likeCount
    self.hashTags = hashTags
    self.isLiked = isLiked
    self.isBlind = isBlind
  }
}
