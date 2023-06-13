//
//  HashTagCell.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit
import Then

protocol HashTagCellDelegate: AnyObject {
  func tapHashTag(_ tag: String)
}

final class HashTagCell: BaseCollectionViewCell {

  // MARK: Properties
  private let tagButton: UIButton = .init()
  weak var delegate: HashTagCellDelegate?

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
      $0.titleLabel?.font = UIFont(size: .Caption, weight: .w600)
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
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.tapHashTag(tagTitle)
      })
      .disposed(by: disposeBag)
  }
}
