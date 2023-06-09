//
//  VideoControllable.swift
//  Feature
//
//  Created by 여정수 on 2023/04/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import DesignKit

protocol VideoControllable {
  var videoPlayerView: VideoPlayerView { get }

  var isMute: Bool { get }
}

extension VideoControllable {
  var isMute: Bool {
    videoPlayerView.player?.isMuted ?? false
  }

  func playVideo() {
    videoPlayerView.player?.startAtBeginning()
  }

  func playAmbientVideo() {
    videoPlayerView.player?.startWithAmbient()
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
