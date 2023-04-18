//
//  UIApplication+.swift
//  Core
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

  // MARK: Methods
  static func presentTokenExpiredAlert() {
    let alertController: UIAlertController = .init(
      title: "세션이 만료되었습니다",
      message: "다시 로그인 후 시도해 주세요",
      preferredStyle: .alert
    )
    alertController.modalPresentationStyle = .overCurrentContext
    alertController.modalTransitionStyle = .crossDissolve
    alertController.view.backgroundColor = .init(named: "mono-gray-800")
    alertController.view.layer.cornerRadius = 16

    alertController.addAction(.init(title: "확인", style: .default, handler: { _ in
      NotificationCenter.default.post(name: .logout, object: nil)
    }))

    keyWindow?.rootViewController?.present(alertController, animated: true)
  }
}
