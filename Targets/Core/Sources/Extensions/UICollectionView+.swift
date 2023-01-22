//
//  UICollectionView+.swift
//  Core
//
//  Created by Ian on 2023/01/22.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UICollectionView {

  // MARK: Methods
  func registerCell(cellType: UICollectionViewCell.Type) {
    let identifer: String = "\(cellType)"
    register(cellType, forCellWithReuseIdentifier: identifer)
  }

  func registerHeader(viewType: UICollectionReusableView.Type) {
    let identifier: String = "\(viewType)"
    register(
      viewType,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: identifier
    )
  }

  func registerFooter(viewType: UICollectionReusableView.Type) {
    let identifier: String = "\(viewType)"
    register(
      viewType,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: identifier
    )
  }

  func dequeue<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
    dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as! T
  }

  func dequeueHeader<T: UICollectionReusableView>(viewType: T.Type, indexPath: IndexPath) -> T {
    dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: "\(viewType)",
      for: indexPath
    ) as! T
  }

  func dequeueFooter<T: UICollectionReusableView>(viewType: T.Type, indexPath: IndexPath) -> T {
    dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: "\(viewType)",
      for: indexPath
    ) as! T
  }
}
