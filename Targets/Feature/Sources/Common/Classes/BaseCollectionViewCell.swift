//
//  BaseCollectionViewCell.swift
//  Feature
//
//  Created by Ian on 2023/01/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

  // MARK: Initialzer
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  func setupViews() {}
  func setupLayoutConstraints() {}
}
