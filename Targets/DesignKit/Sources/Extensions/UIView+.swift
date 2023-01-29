//
//  UIView+.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIView {

  // MARK: Methods
  func setGradient(startColor: UIColor, endColor: UIColor) {
    let topColor: CGColor = startColor.cgColor
    let bottomColor: CGColor = endColor.cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor, bottomColor]
    gradientLayer.locations = [0, 1]
    gradientLayer.frame = bounds

    layer.insertSublayer(gradientLayer, at: 0)
  }

  func setGradientBackground() {
    let startColor: UIColor = .createColor(.monoGray, .w800)
    let endColor: UIColor = .createColor(.monoGray, .w950)

    setGradient(startColor: startColor, endColor: endColor)
  }

  func cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerRadius = radius

    if corners != [.allCorners] {
      var cornerMask: CACornerMask = .init()

      corners.forEach {
        if $0 == .bottomLeft {
          cornerMask.insert(.layerMinXMinYCorner)
        }
        if $0 == .bottomRight {
          cornerMask.insert(.layerMaxXMinYCorner)
        }
        if $0 == .topLeft {
          cornerMask.insert(.layerMinXMaxYCorner)
        }
        if $0 == .topRight {
          cornerMask.insert(.layerMaxXMaxYCorner)
        }
      }

      layer.maskedCorners = cornerMask
    }
  }
}
