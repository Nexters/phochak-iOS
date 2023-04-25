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
}
