//
//  PostsSectionHeaderView.swift
//  PhoChak
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import UIKit

import RxCocoa
import RxSwift

final class PostsSectionHeaderView: UICollectionReusableView {

  // MARK: Properties
  private let uploadedPostButton: PhoChakMenuButton = .init()
  private let likedPostButton: PhoChakMenuButton = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PostsSectionHeaderView {
  var uploadedButtonTap: Observable<Void> {
    uploadedPostButton.rx.tap
      .asObservable()
      .do(onNext: { [weak self] in
        self?.uploadedPostButton.isSelected = true
        self?.likedPostButton.isSelected = false
      })
  }

  var likedButtonTap: Observable<Void> {
    likedPostButton.rx.tap
      .asObservable()
      .do(onNext: { [weak self] in
        self?.uploadedPostButton.isSelected = false
        self?.likedPostButton.isSelected = true
      })
  }
}

// MARK: - Private Extension
private extension PostsSectionHeaderView {
  func setupViews() {
    uploadedPostButton.do {
      $0.setTitle("내 포스팅", for: .normal)
      $0.setupColor(isSelected: true)
      $0.cornerRadius(radius: 20)
      addSubview(uploadedPostButton)
    }

    likedPostButton.do {
      $0.setTitle("포착한 포스팅", for: .normal)
      $0.setupColor(isSelected: false)
      $0.cornerRadius(radius: 20)
      addSubview(likedPostButton)
    }
  }

  func setupLayoutConstraints() {
    uploadedPostButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(CGSize(width: 92, height: 40))
    }

    likedPostButton.snp.makeConstraints {
      $0.leading.equalTo(uploadedPostButton.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(CGSize(width: 120, height: 40))
    }
  }
}
