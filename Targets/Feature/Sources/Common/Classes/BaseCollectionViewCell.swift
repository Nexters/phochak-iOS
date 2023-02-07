//
//  BaseCollectionViewCell.swift
//  Feature
//
//  Created by Ian on 2023/01/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {

  // MARK: Properties
  var disposeBag: DisposeBag = .init()

  // MARK: Override
  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = .init()
  }

  // MARK: Initialzer
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  func setupViews() {}
  func setupLayoutConstraints() {}
}
