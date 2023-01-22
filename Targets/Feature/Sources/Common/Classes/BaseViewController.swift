//
//  BaseViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

class BaseViewController<T: Reactor>: UIViewController, View {
  typealias Reactor = T

  // MARK: Properties
  var disposeBag: DisposeBag = .init()

  // MARK: Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupLayoutConstraints()
  }

  // MARK: Methods
  func bind(reactor: T) {}
  func setupViews() {}
  func setupLayoutConstraints() {}
}
