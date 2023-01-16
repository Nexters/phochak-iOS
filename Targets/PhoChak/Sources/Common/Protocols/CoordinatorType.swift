//
//  CoordinatorType.swift
//  Service
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

protocol CoordinatorType: AnyObject {

  // MARK: Properties
  var children: [CoordinatorType] { get set }
  var router: UINavigationController { get set }

  // MARK: Methods
  func start()
  func addchild(_ child: CoordinatorType)
  func removeChild(_ child: CoordinatorType)
}

// MARK: - Default Implementation
extension CoordinatorType {
  func addChild(_ child: CoordinatorType) {
    children.append(child)
  }

  func removeChild(_ child: CoordinatorType) {
    for (index, coordinator) in children.enumerated() {
      if coordinator === child {
        children.remove(at: index)
      }
    }
  }
}
