//
//  ChangeNickNameResponse.swift
//  Service
//
//  Created by 한상진 on 2023/03/01.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain

public struct ChangeNickNameResponse: Decodable {
  
  // MARK: Properties
  let status: ResponseStatus
  let data: String?
}
