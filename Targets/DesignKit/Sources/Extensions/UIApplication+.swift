//
//  UIApplication+.swift
//  DesignKit
//
//  Created by Ian on 2023/01/20.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UIApplication {

  // MARK: Properties
  static var keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .first?.windows
    .filter { $0.isKeyWindow }.first
}
