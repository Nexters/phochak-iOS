//
//  UIFont+.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIFont {

  // MARK: Properties
  enum FontSizeLiteral: CGFloat {
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

  enum FontWeight {
    case w300
    case w400
    case w500
    case w600
    case w700
    case w800

    fileprivate var fontName: String {
      switch self {
      case .w300: return "Pretendard-Light"
      case .w400: return "Pretendard-Regular"
      case .w500: return "Pretendard-Medium"
      case .w600: return "Pretendard-SemiBold"
      case .w700: return "Pretendard-Bold"
      case .w800: return "Pretendard-ExtraBold"
      }
    }
  }

  // MARK: Initializer
  convenience init?(size: FontSizeLiteral, weight: FontWeight) {
    self.init(name: weight.fontName, size: size.rawValue)
  }
}
