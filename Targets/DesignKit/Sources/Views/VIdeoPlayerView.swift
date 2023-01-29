//
//  VIdeoPlayerView.swift
//  DesignKit
//
//  Created by Ian on 2023/01/24.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import UIKit

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

  // MARK: Override
  public override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
