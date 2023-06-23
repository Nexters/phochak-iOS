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
    guard (layer.sublayers?[0] as? CAGradientLayer) == nil else { return }
    if bounds == .init() { layoutIfNeeded() }

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

  func removeGradient() {
    guard let subLayers = layer.sublayers else {
      return
    }

    for subLayer in subLayers where (subLayer as? CAGradientLayer) != nil {
      subLayer.removeFromSuperlayer()
    }
  }

  func cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerRadius = radius

    guard corners != [.allCorners] else { return }

    var cornerMask: CACornerMask = .init()

    corners.forEach {
      switch $0 {
      case .topLeft: cornerMask.insert(.layerMinXMinYCorner)
      case .topRight: cornerMask.insert(.layerMaxXMinYCorner)
      case .bottomLeft: cornerMask.insert(.layerMinXMaxYCorner)
      case .bottomRight: cornerMask.insert(.layerMaxXMaxYCorner)
      default: break
      }
    }

    layer.maskedCorners = cornerMask
  }

  func addTapGesture() -> UITapGestureRecognizer {
    let tapGestureRecognizer: UITapGestureRecognizer = .init()
    addGestureRecognizer(tapGestureRecognizer)

    return tapGestureRecognizer
  }

  func addDoubleTapGesture() -> UITapGestureRecognizer {
    let tapGesture = addTapGesture()
    tapGesture.numberOfTapsRequired = 2

    return tapGesture
  }
}
