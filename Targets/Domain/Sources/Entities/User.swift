//
//  User.swift
//  Domain
//
//  Created by Ian on 2023/02/07.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct User: Decodable {

  // MARK: Properties
  public let id: Int
  public let nickname: String
  private let profileImageURLString: String

  public var profileImageURL: URL {
    .init(string: profileImageURLString)!
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case nickname
    case profileImageURLString = "profileImgUrl"
  }

  // MARK: Initializer
  public init(id: Int, nickname: String, profileImageURLString: String) {
    self.id = id
    self.nickname = nickname
    self.profileImageURLString = profileImageURLString
  }
}
