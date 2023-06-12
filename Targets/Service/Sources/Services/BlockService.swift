//
//  BlockService.swift
//  Service
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

import Moya
import RxSwift
import RxMoya

public class BlockService: BlockServiceType {

  // MARK: Properties
  private let provider: MoyaProvider<BlockAPI>

  // MARK: Initializer
  init(
    provider: MoyaProvider<BlockAPI> = MoyaProvider<BlockAPI>(plugins: [PCNetworkLoggerPlugin()])
  ) {
    self.provider = provider
  }

  // MARK: Methods
  public func blockUser(userID: Int) -> Single<Void> {
    provider.rx.request(.blockUser(userID: userID))
      .map { _ in }
  }

  public func unBlockUser(userID: Int) -> Single<Void> {
    provider.rx.request(.unBlockUser(userID: userID))
      .map { _ in }
  }

  public func fetchBlockedList() -> Single<[User]> {
    provider.rx.request(.fetchBlockedList)
      .map(BlockedListResponse.self)
      .map { $0.users }
  }
}
