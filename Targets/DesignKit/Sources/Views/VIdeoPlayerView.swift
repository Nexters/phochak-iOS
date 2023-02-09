//
//  VideoPlayerView.swift
//  DesignKit
//
//  Created by Ian on 2023/01/24.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import UIKit

import RxSwift

public final class VideoPlayerView: UIView {

  // MARK: Properties
  public var playerLayer: AVPlayerLayer {
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

  private let disposeBag: DisposeBag = .init()

  // MARK: Override
  public override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)

    NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime)
      .subscribe(with: self, onNext: { owner, _ in
        owner.player?.seek(to: .zero)
        owner.player?.play()
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
