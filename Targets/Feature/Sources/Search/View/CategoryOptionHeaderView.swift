//
//  CategoryOptionHeaderView.swift
//  Feature
//
//  Created by 여정수 on 2023/06/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import RxCocoa

final class CategoryOptionHeaderView: UICollectionReusableView {

  // MARK: Properties
  private let categoryButtonStackView: PostCategoryButtonStackView = .init()
  private let containerView: UIView = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var categoryButtonTapSignal: Signal<PostCategory> {
    Signal<PostCategory>.merge(
      categoryButtonStackView.tourButtonTapSignal.map { _ in PostCategory.tour},
      categoryButtonStackView.restaurantButtonTapSignal.map { _ in PostCategory.restaurant },
      categoryButtonStackView.cafeButtonTapSignal.map { _ in PostCategory.cafe }
    )
    .do(onNext: { [weak self] in
      self?.categoryButtonStackView.selectCategory($0)
    })
  }
}

private extension CategoryOptionHeaderView {
  func setup() {
    addSubview(containerView)
    containerView.addSubview(categoryButtonStackView)

    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    categoryButtonStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(35)
      $0.bottom.equalToSuperview().offset(-15)
    }
  }
}
