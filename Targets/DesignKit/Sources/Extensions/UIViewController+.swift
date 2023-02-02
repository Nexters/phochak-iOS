//
//  UIViewController+.swift
//  DesignKit
//
//  Created by Ian on 2023/01/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {

  // MARK: Properties
  var viewDidLoad: Observable<Void> {
    self.methodInvoked(#selector(Base.viewDidLoad))
      .map { _ in }
  }

  var viewWillAppear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewWillAppear(_:)))
      .map { _ in }
  }

  var viewDidAppear: Observable<Void> {
    self.methodInvoked(#selector(Base.viewDidAppear(_:)))
      .map { _ in }
  }
}

public extension UIViewController {
  static let screenHeight = UIScreen.main.bounds.height
  static let screenWidth = UIScreen.main.bounds.width
}
