//
//  PhoChakMenuButton.swift
//  DesignKit
//
//  Created by 한상진 on 2023/02/04.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift

public final class PhoChakMenuButton: UIButton {

  // MARK: Initializer
  public init() {
    super.init(frame: .zero)

    setupView()
    setupColor(isSelected: false)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  public func setupColor(isSelected: Bool) {
    backgroundColor = isSelected ? .createColor(.monoGray, .w700) : .clear
    setTitleColor(.createColor(.monoGray, isSelected ? .w50 : .w300), for: .normal)
    layer.borderColor = UIColor.createColor(.monoGray, isSelected ? .w600 : .w700).cgColor
  }
}

// MARK: - Private
private extension PhoChakMenuButton {

  // MARK: Methods
  func setupView() {
    titleLabel?.font = UIFont(size: .Body, weight: .w500)
    layer.borderWidth = 0.5
  }
}
