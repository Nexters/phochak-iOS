//
//  VideoPostCell.swift
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

protocol VideoPostCellDelegate: AnyObject {
  func didTapNicknameLabel(targetUserID: Int)
  func didTapLikeButton(postID: Int)
  func didTapExclameButton(postID: Int)
}

final class VideoPostCell: BaseCollectionViewCell, VideoControllable {

  // MARK: Properties
  private let containerView: UIView = .init()
  private let nicknameLabel: UILabel = .init()
  private let exclameButton: ExtendedTouchAreaButton = .init()
  private let likeButton: ExtendedTouchAreaButton = .init()
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

    nicknameLabel.text = nil
    likeButton.imageView?.image = videoPost?.isLiked ?? false ? UIImage(literal: .heartOn) : UIImage(literal: .heartOff)
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

    nicknameLabel.do {
      $0.font = UIFont(size: .Body, weight: .w700)
      $0.textColor = .createColor(.monoGray, .w200)
      $0.isUserInteractionEnabled = true
      containerView.addSubview($0)
    }

    exclameButton.do {
      $0.setImage(UIImage(literal: .exclameOff), for: .normal)
      containerView.addSubview($0)
    }

    likeButton.do {
      $0.setImage(UIImage(literal: .heartOff), for: .normal)
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

    likeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-30)
      $0.bottom.equalToSuperview().offset(-40)
    }

    exclameButton.snp.makeConstraints {
      $0.trailing.equalTo(likeButton.snp.leading).offset(-28)
      $0.bottom.equalTo(likeButton)
    }
  }

  // MARK: Methods
  func configure(_ videoPost: VideoPost) {
    self.videoPost = videoPost
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.6
    nicknameLabel.attributedText = .init(string: videoPost.user.nickname, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    videoPlayerView.configure(videoPost: videoPost)
    likeButton.setImage(videoPost.isLiked ? UIImage(literal: .heartOn) : UIImage(literal: .heartOff), for: .normal)

    nicknameLabel.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .subscribe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.didTapNicknameLabel(targetUserID: videoPost.user.id)
      })
      .disposed(by: disposeBag)

    exclameButton.rx.tap
      .subscribe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.didTapExclameButton(postID: videoPost.id)
      })
      .disposed(by: disposeBag)

    likeButton.rx.tap
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.didTapLikeButton(postID: videoPost.id)
      })
      .disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, notification in
        owner.playerDidReachEnd(notification: notification)
      })
      .disposed(by: disposeBag)
  }
}
