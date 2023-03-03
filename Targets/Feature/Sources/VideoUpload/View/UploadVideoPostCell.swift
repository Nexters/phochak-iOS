//
//  UploadVideoPostCell.swift
//  Feature
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class UploadVideoPostCell: BaseCollectionViewCell {

  // MARK: Properties
  private let tagLabel: UILabel = .init()
  private let deletionButton: UIButton = .init()

  public var deletionButtonTapObservable: Observable<Void> {
    deletionButton.rx.tap.asObservable()
  }

  // MARK: Override
  override func prepareForReuse() {
    super.prepareForReuse()

    tagLabel.text = nil
  }

  override func setupViews() {
    contentView.backgroundColor = .clear

    tagLabel.do {
      $0.textColor = .createColor(.monoGray, .w50)
      $0.font = .createFont(.CallOut, .w500)
      contentView.addSubview($0)
    }

    deletionButton.do {
      $0.setImage(.createImage(.iconX), for: .normal)
      contentView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    tagLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(14)
      $0.leading.equalToSuperview().offset(20)
    }

    deletionButton.snp.makeConstraints {
      $0.leading.equalTo(tagLabel.snp.trailing).offset(10)
      $0.top.bottom.equalToSuperview().inset(12)
      $0.trailing.equalToSuperview().inset(15)
    }
  }

  // MARK: Methods
  func configure(tagText: String) {
    tagLabel.text = tagText
  }
}
