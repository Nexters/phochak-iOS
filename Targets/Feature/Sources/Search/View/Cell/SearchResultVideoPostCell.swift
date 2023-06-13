//
//  SearchResultVideoPostCell.swift
//  Feature
//
//  Created by 여정수 on 2023/05/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import DesignKit
import Domain
import UIKit

import RxSwift

final class SearchResultVideoPostCell: BaseCollectionViewCell, VideoControllable {

  // MARK: Properties
  private let containerView: UIView = .init()
  private let likeImageView: UIImageView = .init(image: UIImage(literal: .heartOn))
  private let likeCountLabel: UILabel = .init()
  let videoPlayerView: VideoPlayerView = .init()

  private var videoPost: VideoPost?

  weak var delegate: VideoPostCellDelegate?

  // MARK: Override
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    likeCountLabel.text = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    containerView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0),
      endColor: .createColor(.monoGray, .w950, alpha: 0.9)
    )
  }

  override func setupViews() {
    contentView.cornerRadius(radius: 5)
    contentView.addSubview(videoPlayerView)
    contentView.addSubview(containerView)
    containerView.addSubview(likeImageView)

    likeCountLabel.do {
      $0.font = UIFont(size: .Body, weight: .w300)
      $0.textColor = .createColor(.monoGray, .w50)
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

    likeImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(14)
      $0.size.equalTo(CGSize(width: 12, height: 10.5))
      $0.bottom.equalToSuperview().offset(-13.5)
    }

    likeCountLabel.snp.makeConstraints {
      $0.leading.equalTo(likeImageView.snp.trailing).offset(7)
      $0.centerY.equalTo(likeImageView)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }

  // MARK: Methods
  func configure(_ videoPost: VideoPost) {
    self.videoPost = videoPost

    videoPlayerView.configure(videoPost: videoPost, autoPlayWhenPlayerReady: false)
    likeCountLabel.text = "\(videoPost.likeCount)"
  }
}

