//
//  VideoPostSection.swift
//  Feature
//
//  Created by 한상진 on 2023/06/14.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import RxDataSources

struct VideoPostSection: Equatable {

  // MARK: Properties
  var header: String
  var items: [VideoPost]
}

extension VideoPostSection: AnimatableSectionModelType {

  // MARK: Properties
  var identity: String {
    return header
  }

  // MARK: Initializer
  init(original: VideoPostSection, items: [VideoPost]) {
    self = original
    self.items = items
  }
}
