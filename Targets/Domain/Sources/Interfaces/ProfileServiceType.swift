//
//  ProfileServiceType.swift
//  Domain
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public protocol ProfileServiceType {

  // MARK: Methods
  func fetchUserProfile(userID: String) -> Single<User>
}
