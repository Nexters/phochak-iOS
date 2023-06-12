//
//  UserNameSection.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxDataSources

struct UserNameSection: Equatable {

  // MARK: Properties
  var header: String
  var items: [String]
}

extension UserNameSection: AnimatableSectionModelType {

  // MARK: Properties
  var identity: String {
    return header
  }

  // MARK: Initializer
  init(original: UserNameSection, items: [String]) {
    self = original
    self.items = items
  }
}
