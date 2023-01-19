//
//  PhoChakFont.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public struct PhoChakFont {

  // MARK: Properties
  public enum FontSize: CGFloat {
    case LargeTitle = 32
    case Title1 = 28
    case Title2 = 24
    case Title3 = 20
    case HeadLine = 18
    case SubHead = 16
    case CallOut = 15
    case Body = 14
    case FootNote = 13
    case Caption = 12
  }

  // MARK: Methods
  public static func createFont(_ size: FontSize, _ weight: Int) -> UIFont {
    var fontName: String {
      switch weight {
      case 800: return "Pretendard-ExtraBold"
      case 700: return "Pretendard-Bold"
      case 600: return "Pretendard-SemiBold"
      case 500: return "Pretendard-Medium"
      case 400: return "Pretendard-Regular"
      case 300: return "Pretendard-Light"
      default: return .init()
      }
    }

    guard let font: UIFont = .init(name: fontName, size: size.rawValue) else { return .init() }
    return font
  }
}
