//
//  BlockServiceType.swift
//  Domain
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol BlockServiceType {

  // MARK: Methods
  func blockUser(userID: Int) -> Single<Void>
  func unBlockUser(userID: Int) -> Single<Void>
  func fetchBlockedList() -> Single<[User]>
}
