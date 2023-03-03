//
//  ProfileSettingServiceType.swift
//  Domain
//
//  Created by 한상진 on 2023/03/01.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol ProfileSettingServiceType {

  // MARK: Methods
  func checkDuplicationNickName(nickName: String) -> Single<Bool>
  func changeNickName(nickName: String) -> Single<Void>
}
