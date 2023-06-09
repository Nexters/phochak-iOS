//
//  AVPlayer+.swift
//  Feature
//
//  Created by 여정수 on 2023/04/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation

extension AVPlayer {
  func stopAtBeginning() {
    seek(to: .zero) { [weak self] _ in
      self?.pause()
    }
  }

  func startAtBeginning() {
    seek(to: .zero, completionHandler: { [weak self] _ in
      self?.play()
    })
  }

  func startWithAmbient() {
    let audioSession = AVAudioSession.sharedInstance()

    if audioSession.category != .ambient {
      DispatchQueue.main.async {
        try? audioSession.setCategory(.ambient, options: [.allowBluetooth])
        try? audioSession.setActive(true)
      }
    }

    seek(to: .zero, completionHandler: { [weak self] _ in
      self?.play()
    })
  }
}
