//
//  MyPagePostCell.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

protocol MyPagePostCellDelegate: AnyObject {
  func tapPost(videoPost: VideoPost)
  func tapOptionButton(indexNumber: Int, optionButton: UIButton)
}

extension MyPagePostCellDelegate {
  func tapOptionButton(indexNumber: Int, optionButton: UIButton) {}
}

final class MyPagePostCell: BaseCollectionViewCell {

  // MARK: Properties
  private let thumbnailImageView: UIImageView = .init()
  private let likeImageView: UIImageView = .init()
  private let likeCountLabel: UILabel = .init()
  private let optionButton: UIButton = .init()
  private let gradientView: UIView = .init()
  private lazy var alphaView: UIView = .init()
  private lazy var exclamedImageView: UIImageView = .init()
  weak var delegate: MyPagePostCellDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func prepareForReuse() {
    super.prepareForReuse()

    thumbnailImageView.image = nil
    likeCountLabel.text = nil
    alphaView.removeFromSuperview()
    exclamedImageView.removeFromSuperview()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    gradientView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0),
      endColor: .createColor(.monoGray, .w950, alpha: 0.9)
    )
  }

  override func setupViews() {
    contentView.cornerRadius(radius: 10)

    thumbnailImageView.do {
      $0.contentMode = .scaleAspectFill
      contentView.addSubview($0)
    }

    likeImageView.do {
      $0.image = UIImage(literal: .heartOn)
      contentView.addSubview($0)
    }

    likeCountLabel.do {
      $0.font = UIFont(size: .Caption, weight: .w300)
      $0.textColor = .createColor(.monoGray, .w50)
      contentView.addSubview($0)
    }

    optionButton.do {
      $0.setImage(UIImage(literal: .option), for: .normal)
      contentView.addSubview($0)
    }

    gradientView.do {
      thumbnailImageView.addSubview($0)
    }

    alphaView.do {
      $0.backgroundColor = .createColor(.monoGray, .w950, alpha: 0.5)
    }

    exclamedImageView.do {
      $0.image = UIImage(literal: .exclamed)
    }
  }

  override func setupLayoutConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    likeImageView.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 12, height: 10.7))
      $0.leading.equalToSuperview().offset(14)
      $0.bottom.equalToSuperview().offset(-14.3)
    }

    likeCountLabel.snp.makeConstraints {
      $0.leading.equalTo(likeImageView.snp.trailing).offset(7)
      $0.centerY.equalTo(likeImageView)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    optionButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(12)
      $0.size.equalTo(CGSize(width: 24, height: 24))
    }

    gradientView.snp.makeConstraints {
      $0.height.equalToSuperview().multipliedBy(0.5)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  // MARK: Methods
  func configure(videoPost: VideoPost, hideOption: Bool = false, indexNumber: Int) {
    if videoPost.isBlind {
      setBlind()
    }

    thumbnailImageView.kf.setImage(with: videoPost.shorts.thumbnailURL)
    likeCountLabel.text = "\(videoPost.likeCount)"
    optionButton.isHidden = hideOption

    contentView.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.tapPost(videoPost: videoPost)
      })
      .disposed(by: disposeBag)

    optionButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapOptionButton(
          indexNumber: indexNumber,
          optionButton: owner.optionButton
        )
      })
      .disposed(by: disposeBag)
  }

  private func setBlind() {
    thumbnailImageView.addSubview(alphaView)
    alphaView.addSubview(exclamedImageView)

    alphaView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    exclamedImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
