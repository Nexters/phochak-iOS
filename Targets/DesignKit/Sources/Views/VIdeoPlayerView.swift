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

    NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime)
      .subscribe(with: self, onNext: { owner, notification in
        owner.playerDidReachEnd(notification: notification)
      })
      .disposed(by: disposeBag)

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
  public func configure(videoPost: VideoPost) {
    thumbnailImageView.setImage(with: videoPost.shorts.thumbnailURL)

    self.player = .init(url: videoPost.shorts.shortsURL).then {
      $0.isMuted = true
    }

    player?.currentItem?.rx.observe(\.status)
      .filter { $0 == .readyToPlay }
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, _ in
        owner.thumbnailImageView.image = nil
        owner.player?.play()
      })
      .disposed(by: disposeBag)
  }
}

private extension VideoPlayerView {
  func playerDidReachEnd(notification: Notification) {
    if let playerItem = notification.object as? AVPlayerItem {
      playerItem.seek(to: CMTime.zero, completionHandler: nil)
      player?.play()
    }
  }
}
