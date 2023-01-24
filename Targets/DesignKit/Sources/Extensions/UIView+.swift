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
}
