//
//  UIImageView+.swift
//  DesignKit
//
//  Created by Ian on 2023/02/11.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import Kingfisher

public extension UIImageView {
  func setImage(with url: URL) {
    ImageCache.default.retrieveImage(
      forKey: url.absoluteString,
      options: nil
    ) { result in
      switch result {
      case .success(let cacheResult):
        if let image = cacheResult.image {
          self.image = image
        } else {
          let resource: ImageResource = .init(downloadURL: url, cacheKey: url.absoluteString)
          self.kf.setImage(with: resource, options: [.transition(.fade(0.3))])
        }

      default:
        return
      }
    }
  }
}
