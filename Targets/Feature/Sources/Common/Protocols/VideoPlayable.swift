//
//  VideoPlayable.swift
//  Feature
//
//  Created by 여정수 on 2023/04/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import DesignKit

protocol VideoPlayable {
  var videoPlayerView: VideoPlayerView { get }
}

extension VideoPlayable {
  func playVideo() {
    videoPlayerView.player?.play()
  }

  func stopVideo() {
    videoPlayerView.player?.stopAtBeginning()
  }

  func playerDidReachEnd(notification: Notification) {
    if let playerItem = notification.object as? AVPlayerItem,
       playerItem == videoPlayerView.player?.currentItem {
      playerItem.seek(to: .zero) { _ in
        playVideo()
      }
    }
  }
}
