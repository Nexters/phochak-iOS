//
//  FeedbackGenerator.swift
//  Feature
//
//  Created by 여정수 on 2023/04/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

final class FeedbackGenerator {

  // MARK: Properties
  static let shared: FeedbackGenerator = .init()
  private let generator: UINotificationFeedbackGenerator = .init()

  // MARK: Initializer
  private init() { }

  // MARK: Methods
  func generate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.prepare()

    generator.notificationOccurred(type)
  }
}
