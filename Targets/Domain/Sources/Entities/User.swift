//
//  User.swift
//  Domain
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct User: Decodable, Equatable {

  // MARK: Properties
  public let id: Int
  public let nickname: String
  private let profileImageURLString: String?
  public let isMe: Bool?
  public let isBlocked: Bool?
  public let isIgnored: Bool?

  public var profileImageURL: URL? {
    if let profileImageURLString = profileImageURLString {
      return .init(string: profileImageURLString)
    }
    return nil
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case nickname
    case profileImageURLString = "profileImgUrl"
    case isMe = "isMyPage"
    case isBlocked = "isIgnored"
    case isIgnored = "isBlocked"
  }

  // MARK: Initializer
  public init(
    id: Int,
    nickname: String,
    profileImageURLString: String,
    isMe: Bool,
    isIgnored: Bool,
    isBlocked: Bool
  ) {
    self.id = id
    self.nickname = nickname
    self.profileImageURLString = profileImageURLString
    self.isMe = isMe
    self.isIgnored = isIgnored
    self.isBlocked = isBlocked
  }

  // MARK: Methods
  public static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
  }
}
