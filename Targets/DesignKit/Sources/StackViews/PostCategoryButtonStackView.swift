//
//  PostCategoryButtonStackView.swift
//  DesignKit
//
//  Created by 한상진 on 2023/02/04.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

public final class PostCategoryButtonStackView: UIStackView {

  // MARK: Properties
  private let tourButton: PhoChakMenuButton = .init()
  private let restaurantButton: PhoChakMenuButton = .init()
  private let cafeButton: PhoChakMenuButton = .init()
  private var allButtons: [PhoChakMenuButton] {
    return [tourButton, restaurantButton, cafeButton]
  }

  public var tourButtonTapSignal: Signal<Void> {
    tourButton.rx.tap.asSignal()
  }
  public var restaurantButtonTapSignal: Signal<Void> {
    restaurantButton.rx.tap.asSignal()
  }
  public var cafeButtonTapSignal: Signal<Void> {
    cafeButton.rx.tap.asSignal()
  }
  public var isTappedSignal: Signal<Bool> {
    Signal.merge(tourButtonTapSignal, restaurantButtonTapSignal, cafeButtonTapSignal)
      .map { true }
  }

  // MARK: Initializer
  public init() {
    super.init(frame: .zero)

    setupViews()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  public override func layoutSubviews() {
    super.layoutSubviews()

    setupCornerRadius()
  }

  // MARK: Methods
  public func selectCategory(_ category: PostCategory) {
    switch category {
    case .tour:
      tourButton.setupColor(isSelected: true)
      restaurantButton.setupColor(isSelected: false)
      cafeButton.setupColor(isSelected: false)
    case .restaurant:
      tourButton.setupColor(isSelected: false)
      restaurantButton.setupColor(isSelected: true)
      cafeButton.setupColor(isSelected: false)
    case .cafe:
      tourButton.setupColor(isSelected: false)
      restaurantButton.setupColor(isSelected: false)
      cafeButton.setupColor(isSelected: true)
    }
  }
}

// MARK: - Private
private extension PostCategoryButtonStackView {

  // MARK: Methods
  func setupViews() {
    spacing = 10
    distribution = .fillEqually

    tourButton.do {
      $0.setTitle("여행", for: .normal)
      addArrangedSubview($0)
    }

    restaurantButton.do {
      $0.setTitle("맛집", for: .normal)
      addArrangedSubview($0)
    }

    cafeButton.do {
      $0.setTitle("카페", for: .normal)
      addArrangedSubview($0)
    }
  }

  func setupCornerRadius() {
    allButtons.forEach {
      $0.cornerRadius(radius: $0.frame.height / 2)
    }
  }
}
