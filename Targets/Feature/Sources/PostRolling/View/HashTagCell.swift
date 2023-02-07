//
//  HashTagCell.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class HashTagCell: BaseCollectionViewCell {

  // MARK: Properties
  private let tagButton: UIButton = .init()

  // MARK: Override
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    tagButton.titleLabel?.text = nil
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupViews() {
    contentView.backgroundColor = .clear

    tagButton.do {
      $0.backgroundColor = .clear
      $0.setTitleColor(.createColor(.monoGray, .w50), for: .normal)
      $0.titleLabel?.font = .createFont(.Caption, .w600)
      contentView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    tagButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  // MARK: Methods
  func configure(tagTitle: String) {
    tagButton.setTitle("#" + tagTitle, for: .normal)

    tagButton.rx.tap
      .asSignal()
      .map { _ in tagTitle }
      .emit(with: self, onNext: { owner, tag in
        // TODO: 검색화면 구현 이후 업데이트
        print("✅ \(#function) - \(#line): \(tag)")
      })
      .disposed(by: disposeBag)
  }
}
