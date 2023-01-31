//
//  Shorts.swift
//  Domain
//
//  Created by Ian on 2023/01/27.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct Shorts {

  // MARK: Properties
  let id: Int
  let shortsURLString: String
  let thumbnailURLString: String

  public var shortsURL: URL {
    .init(string: shortsURLString)!
  }

  public var thumbnailURL: URL {
    .init(string: thumbnailURLString)!
  }

  private enum CodingKeys: String, CodingKey {
    case id = "shortsId"
    case shortsURLString = "shortsUrl"
    case thumbnailURLString = "thumbnailUrl"
  }

  public init(id: Int, shortsURLString: String, thumbnailURLString: String) {
    self.id = id
    self.shortsURLString = shortsURLString
    self.thumbnailURLString = thumbnailURLString
  }
}
