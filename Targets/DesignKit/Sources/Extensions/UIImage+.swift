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
    case logo = "logo"
    case back = "back"
    case dots = "dots"
    case exclame = "exclame"
    case exclameOff = "exclame_off"
    case filter = "filter"
    case heartOff = "heart_off"
    case heartOn = "heart_on"
    case iconX = "iconX"
    case kakao = "kakao"
    case apple = "apple"
    case search = "search"
    case setting = "setting"
    case tab_home = "tab_home"
    case tab_home_selected = "tab_home_selected"
    case tab_videoUpload = "tab_videoUpload"
    case tab_profile = "tab_profile"
    case tab_profile_selected = "tab_profile_selected"
    case close = "close"
    case option = "option"
    case deleteVideoPost = "deleteVideoPost"
  }

  // MARK: Methods
  static func createImage(_ image: ImageLiteral) -> UIImage {
    guard let image: UIImage = .init(named: image.rawValue) else { return .init() }

    return image
  }
}
