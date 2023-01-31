//
//  UIColor+.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIColor {

  // MARK: Properties
  enum ColorLiteral: String {
    case monoGray = "mono-gray-"
    case red = "red-"
    case yellow = "yellow-"
    case green = "green-"
    case blue = "blue-"
  }

  enum ColorWeight: String {
    case w50 = "50"
    case w100 = "100"
    case w200 = "200"
    case w300 = "300"
    case w400 = "400"
    case w500 = "500"
    case w600 = "600"
    case w700 = "700"
    case w800 = "800"
    case w900 = "900"
    case w950 = "950"
  }

  // MARK: Methods
  static func createColor(_ color: ColorLiteral, _ weight: ColorWeight, alpha: CGFloat = 1.0) -> UIColor {
    guard let color: UIColor = .init(named: color.rawValue + weight.rawValue) else { return .init() }
    color.withAlphaComponent(alpha)

    return color
  }
}
