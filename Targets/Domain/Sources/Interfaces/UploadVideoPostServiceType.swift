//
//  UploadVideoPostServiceType.swift
//  Domain
//
//  Created by 한상진 on 2023/02/06.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

import RxSwift

public protocol UploadVideoPostServiceType {

  // MARK: Methods
  func uploadVideoPost(
    videoFile: VideoFile,
    category: String,
    hashTags: [String]
  ) -> Single<Void>
}
