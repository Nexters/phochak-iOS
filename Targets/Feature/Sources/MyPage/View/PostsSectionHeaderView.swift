//
//  PostsSectionHeaderView.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import RxCocoa
import RxSwift

protocol PostsSectionHeaderDelegate: AnyObject {
  func updateFilter(postFilter: PostsFilterOption)
}

final class PostsSectionHeaderView: UICollectionReusableView {

  // MARK: Properties
  private let uploadedPostButton: PhoChakMenuButton = .init()
  private let likedPostButton: PhoChakMenuButton = .init()
  private let disposeBag: DisposeBag = .init()
  weak var delegate: PostsSectionHeaderDelegate?

  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()

    Observable.merge(
      uploadedPostButton.rx.tap.asObservable().map { _ in PostsFilterOption.uploaded },
      likedPostButton.rx.tap.asObservable().map { _ in PostsFilterOption.liked }
    )
    .subscribe(on: MainScheduler.instance)
    .subscribe(with: self, onNext: { owner, filter in
      owner.updatePostsFilter(filter: filter)
    })
    .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      $0.top.equalToSuperview().offset(10)
      $0.size.equalTo(CGSize(width: 92, height: 40))
    }

    likedPostButton.snp.makeConstraints {
      $0.leading.equalTo(uploadedPostButton.snp.trailing).offset(10)
      $0.top.equalToSuperview().offset(10)
      $0.size.equalTo(CGSize(width: 120, height: 40))
    }
  }

  func updatePostsFilter(filter: PostsFilterOption) {
    switch filter {
    case .uploaded:
      uploadedPostButton.setupColor(isSelected: true)
      likedPostButton.setupColor(isSelected: false)
    case .liked:
      uploadedPostButton.setupColor(isSelected: false)
      likedPostButton.setupColor(isSelected: true)
    }
    delegate?.updateFilter(postFilter: filter)
  }
}
