//
//  VideoPlayerView.swift
//  DesignKit
//
//  Created by Ian on 2023/01/24.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import Domain
import UIKit

import Kingfisher
import RxSwift

public final class VideoPlayerView: UIView {

  // MARK: Properties
  private var playerLayer: AVPlayerLayer {
    let layer = layer as! AVPlayerLayer
    layer.videoGravity = .resizeAspectFill
    return layer
  }

  public var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }

  private let thumbnailImageView: UIImageView = .init()
  private let disposeBag: DisposeBag = .init()
  private(set) var currentVideoPost: VideoPost?

  // MARK: Override
  public override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)

    addSubview(thumbnailImageView)
    thumbnailImageView.contentMode = .scaleAspectFill
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    NotificationCenter.default.rx.notification(.muteAllPlayers)
      .subscribe(with: self, onNext: { owner, _ in
        owner.player?.isMuted = true
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  public func configure(videoPost: VideoPost, autoPlayWhenPlayerReady: Bool = true) {
    guard currentVideoPost?.id != videoPost.id else {
      return
    }

    self.currentVideoPost = videoPost
    thumbnailImageView.setImage(with: videoPost.shorts.thumbnailURL)

    self.player = .init(url: videoPost.shorts.shortsURL).then {
      $0.isMuted = true
    }

    if autoPlayWhenPlayerReady {
      player?.currentItem?.rx.observe(\.status)
        .filter { $0 == .readyToPlay }
        .asDriver(onErrorDriveWith: .empty())
        .drive(with: self, onNext: { owner, _ in
          owner.thumbnailImageView.image = nil
        })
        .disposed(by: disposeBag)
    }
  }
}
