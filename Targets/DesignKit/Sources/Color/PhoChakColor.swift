//
//  PhoChakColor.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public struct PhoChakColor {

  // MARK: Properties
  public enum ColorType: String {
    case monoGray = "mono-gray-"
    case red = "red-"
    case yellow = "yellow-"
    case green = "green-"
    case blue = "blue-"
  }

  // MARK: Methods
  public static func createColor(_ colorType: ColorType, _ weight: Int) -> UIColor {
    let weight = String(weight)

    guard let color: UIColor = .init(named: colorType.rawValue + weight) else { return .init() }
    return color
  }
}
