//
//  VideoFile.swift
//  Domain
//
//  Created by 한상진 on 2023/02/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

public struct VideoFile {
  public let fileName: String
  public let fileType: String

  public init(fileName: String, fileType: String) {
    self.fileName = fileName
    self.fileType = fileType
  }
}
