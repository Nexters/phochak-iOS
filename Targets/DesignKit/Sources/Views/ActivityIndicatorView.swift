//
//  ActivityIndicatorView.swift
//  DesignKit
//
//  Created by 여정수 on 2023/05/21.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public final class ActivityIndicatorView {

  // MARK: Properties
  private static var indicatorView: UIActivityIndicatorView?

  // MARK: Methods
  public static func show() {
    DispatchQueue.main.async {
      guard let window = UIApplication.keyWindow else {
        return
      }

      let indicatorView: UIActivityIndicatorView
      if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
        indicatorView = existedView
      } else {
        indicatorView = .init(style: .large).then {
          $0.frame = window.frame
          $0.color = .white
          window.addSubview($0)
        }

        indicatorView.startAnimating()
      }
    }
  }

  public static func hide() {
    DispatchQueue.main.async {
      guard let window = UIApplication.keyWindow else {
        return
      }

      window.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
  }
}
