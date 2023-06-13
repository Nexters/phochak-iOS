//
//  BlockUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol BlockUseCaseType {
  var blockService: BlockServiceType { get }

  // MARK: Methods
  func blockUser(userID: Int) -> Observable<Void>
  func unBlockUser(userID: Int) -> Observable<Void>
  func fetchBlockedList() -> Observable<[User]>
}

extension BlockUseCaseType {
  func blockUser(userID: Int) -> Observable<Void> {
    blockService.blockUser(userID: userID).asObservable()
  }

  func unBlockUser(userID: Int) -> Observable<Void> {
    blockService.unBlockUser(userID: userID).asObservable()
  }

  func fetchBlockedList() -> Observable<[User]> {
    blockService.fetchBlockedList().asObservable()
  }
}

final class BlockUseCase: BlockUseCaseType {

  // MARK: Properties
  let blockService: BlockServiceType

  // MARK: Initializer
  init(blockService: BlockServiceType) {
    self.blockService = blockService
  }
}
