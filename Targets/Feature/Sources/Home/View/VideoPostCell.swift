//
//  VideoFeedCell.swift
//  Feature
//
//  Created by Ian on 2023/01/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import DesignKit
import Domain
import UIKit

import RxSwift

final class VideoPostCell: BaseCollectionViewCell {

  // MARK: Properties
  private let containerView: UIView = .init()
  private let nicknameLabel: UILabel = .init()
  private let exclameButton: UIButton = .init()
  private let heartButton: UIButton = .init()
  private let videoPlayerView: VideoPlayerView = .init()

  private var videoPost: VideoPost?

  // MARK: Override
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    nicknameLabel.text = nil
    heartButton.imageView?.image = videoPost?.isLiked ?? false ? .createImage(.heartOn) : .createImage(.heartOff)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let gradient: CAGradientLayer = .init()
    gradient.frame = .init(
      x: 0, y: 0, width: contentView.frame.width,
      height: contentView.frame.height * 0.18
    )
    gradient.colors = [
      UIColor.clear.cgColor,
      UIColor.createColor(.monoGray, .w950, alpha: 0.9).cgColor
    ]
    gradient.locations = [0.0, 1.0]
    containerView.layer.insertSublayer(gradient, at: 0)
  }

  override func setupViews() {
    contentView.cornerRadius(radius: 5)
    contentView.addSubview(videoPlayerView)
    contentView.addSubview(containerView)

    nicknameLabel.do {
      $0.font = .createFont(.HeadLine, .w700)
      $0.textColor = .createColor(.monoGray, .w200)
      containerView.addSubview($0)
    }

    exclameButton.do {
      $0.setImage(.createImage(.exclameOff), for: .normal)
      containerView.addSubview($0)
    }

    heartButton.do {
      $0.setImage(.createImage(.heartOff), for: .normal)
      containerView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    videoPlayerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    containerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.18)
    }

    nicknameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(30)
      $0.bottom.equalToSuperview().offset(-40)
    }

    heartButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-30)
      $0.bottom.equalToSuperview().offset(-40)
    }

    exclameButton.snp.makeConstraints {
      $0.trailing.equalTo(heartButton.snp.leading).offset(-28)
      $0.bottom.equalTo(heartButton)
    }
  }

  // MARK: Methods
  func configure(_ videoPost: VideoPost) {
    self.videoPost = videoPost
    nicknameLabel.text = videoPost.user.nickname
    videoPlayerView.configure(videoPost: videoPost, isMuted: true)

    containerView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0),
      endColor: .createColor(.monoGray, .w950, alpha: 0.9)
    )

    heartButton.setImage(videoPost.isLiked ? .createImage(.heartOn) : .createImage(.heartOff), for: .normal)
  }
}

extension VideoPostCell {
  var exclameButtonTapObservable: Observable<Int> {
    exclameButton.rx.tap
      .asObservable()
      .map { [weak self] in self?.videoPost?.id ?? 0 }
  }

  var heartButtonTapObservable: Observable<Int> {
    heartButton.rx.tap
      .asObservable()
      .map { [weak self] in self?.videoPost?.id ?? 0 }
  }
}
