//
//  HashTagSection.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxDataSources

struct HashTagSection: Equatable {

  // MARK: Properties
  let header: String
  var items: [String]
}

extension HashTagSection: AnimatableSectionModelType {

  // MARK: Properties
  typealias Item = String

  var identity: String {
    return header
  }

  // MARK: Initializer
  init(original: HashTagSection, items: [String]) {
    self = original
    self.items = items
  }
}
