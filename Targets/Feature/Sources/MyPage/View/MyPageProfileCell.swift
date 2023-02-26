//
//  MyPageProfileCell.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

protocol MyPageProfileCellDelegate: AnyObject {
  func tapEditProfileButton()
}

final class MyPageProfileCell: BaseCollectionViewCell {

  // MARK: Properties
  private let nicknameLabel: UILabel = .init()
  private let editProfileButton: UIButton = .init()
  weak var delegate: MyPageProfileCellDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func setupViews() {
    nicknameLabel.do {
      $0.font = .createFont(.Title3, .w700)
      $0.textColor = .white
      contentView.addSubview($0)
    }

    editProfileButton.do {
      $0.setTitle("프로필 편집", for: .normal)
      $0.setTitleColor(.createColor(.blue, .w400), for: .normal)
      $0.titleLabel?.font = .createFont(.Caption, .w500)
      contentView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    editProfileButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }

    nicknameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.lessThanOrEqualTo(editProfileButton.snp.leading).offset(-15)
      $0.centerY.equalToSuperview()
    }
  }

  // MARK: Methods
  func configure(nickname: String) {
    self.nicknameLabel.text = nickname

    editProfileButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.tapEditProfileButton()
      })
      .disposed(by: disposeBag)
  }
}
