//
//  PostCategory.swift
//  Domain
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public enum PostCategory {
  case tour
  case restaurant
  case cafe

  public var uppercasedString: String {
    switch self {
    case .tour: return "TOUR"
    case .restaurant: return "RESTAURANT"
    case .cafe: return "CAFE"
    }
  }
}
