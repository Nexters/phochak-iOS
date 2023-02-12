//
//  UploadVideoPostResponse.swift
//  Service
//
//  Created by 한상진 on 2023/02/09.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct UploadVideoPostResponse: Decodable {

  // MARK: Properties
  let status: ResponseStatus
  let data: String?
}
