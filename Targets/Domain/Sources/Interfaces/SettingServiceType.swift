//
//  SettingServiceType.swift
//  Domain
//
//  Created by 한상진 on 2023/03/02.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

import RxSwift

public protocol SettingServiceType {

  // MARK: Methods
  func withdrawal() -> Single<Void>
  func signOut() -> Single<Void>
}
