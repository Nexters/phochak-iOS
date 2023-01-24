//
//  UIImage+.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIImage {

  // MARK: Properties
  enum ImageLiteral: String {
    case back = "back"
    case dots = "dots"
    case exclame = "exclame"
    case filter = "filter"
    case heart = "heart"
    case iconX = "iconX"
    case kakao = "kakao"
    case search = "search"
    case setting = "setting"
  }

  // MARK: Methods
  static func createImage(_ image: ImageLiteral) -> UIImage {
    guard let image: UIImage = .init(named: image.rawValue) else { return .init() }

    return image
  }
}
