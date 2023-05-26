//
//  UINavigationController+.swift
//  DesignKit
//
//  Created by 여정수 on 2023/05/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UINavigationController {
  func pushWithAnimation(_ viewController: UIViewController, animated: Bool = false) {
    let animation: CATransition = .init()
    animation.duration = 0.35
    animation.type = .fade
    self.view.layer.add(animation, forKey: kCATransition)
    self.pushViewController(viewController, animated: animated)
  }

  func popWithAnimation() {
    let animation: CATransition = .init()
    animation.duration = 0.35
    animation.type = .fade
    self.view.layer.add(animation, forKey: kCATransition)
    self.popViewController(animated: false)
  }
}
