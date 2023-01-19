//
//  UIViewController+.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIViewController {
  func setGradientBackground() {
    let topColor = PhoChakColor.createColor(.monoGray, 800).cgColor
    let bottomColor = PhoChakColor.createColor(.monoGray, 950).cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor, bottomColor]
    gradientLayer.locations = [0, 1]
    gradientLayer.frame = self.view.bounds

    self.view.layer.insertSublayer(gradientLayer, at:0)
  }
}
