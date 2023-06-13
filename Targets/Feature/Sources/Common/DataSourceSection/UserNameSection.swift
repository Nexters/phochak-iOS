//
//  StringArraySection.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxDataSources

struct StringArraySection: Equatable {

  // MARK: Properties
  var header: String
  var items: [String]
}

extension StringArraySection: AnimatableSectionModelType {

  // MARK: Properties
  var identity: String {
    return header
  }

  // MARK: Initializer
  init(original: StringArraySection, items: [String]) {
    self = original
    self.items = items
  }
}
