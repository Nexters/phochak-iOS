//
//  UICollectionViewCell+.swift
//  DesignKit
//
//  Created by 여정수 on 2023/05/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
  func applyLagreScaleTransform(_ completion: (() -> Void)? = nil) {
    if self.transform.isIdentity {
      self.transform = .init(scaleX: 1.1, y: 1.1).translatedBy(x: 0, y: -20)
    }

    completion?()
  }

  func applyIdentityTransform(_ completion: (() -> Void)? = nil) {
    if !self.transform.isIdentity {
      self.transform = .identity
    }

    completion?()
  }
}
