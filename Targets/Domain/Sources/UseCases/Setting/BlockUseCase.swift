//
//  BlockUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol BlockUseCaseType {

  // MARK: Methods
  func blockUser(userID: Int) -> Observable<Void>
  func unBlockUser(userID: Int) -> Observable<Void>
  func fetchBlockedList() -> Observable<[User]>
}

final class BlockUseCase: BlockUseCaseType {

  // MARK: Properties
  let service: BlockServiceType

  // MARK: Initializer
  init(service: BlockServiceType) {
    self.service = service
  }

  func blockUser(userID: Int) -> Observable<Void> {
    service.blockUser(userID: userID).asObservable()
  }

  func unBlockUser(userID: Int) -> Observable<Void> {
    service.unBlockUser(userID: userID).asObservable()
  }

  func fetchBlockedList() -> Observable<[User]> {
    service.fetchBlockedList().asObservable()
  }
}
