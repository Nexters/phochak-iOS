//
//  PhoChakFileManager.swift
//  Core
//
//  Created by 한상진 on 2023/02/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public struct PhoChakFileManager {

  // MARK: Properties
  public static let shared = PhoChakFileManager()
  private let fileManager = FileManager.default

  private var documentDirectoryURL: URL {
    fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }

  private var uploadedVideosFolderURL: URL {
    documentDirectoryURL.appendingPathComponent("UploadedVideos")
  }

  // MARK: Methods
  public func saveVideo(name: String, data: Data) {
    if !fileManager.fileExists(atPath: uploadedVideosFolderURL.path) {
      do {
        try fileManager.createDirectory(
          atPath: uploadedVideosFolderURL.path,
          withIntermediateDirectories: true,
          attributes: nil
        )
      } catch {
        print("⚠️ \(#function) - \(#line)")
      }
    }

    let path = uploadedVideosFolderURL.appendingPathComponent(name)

    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try data.write(to: path, options: .atomic)
      } catch {
        print("⚠️ \(#function) - \(#line)")
      }
    }
  }

  public func fetchVideoURLString(name: String) -> String {
    return "\(uploadedVideosFolderURL.path)/\(name)"
  }

  public func removeUploadedVideos() {
    do {
      try fileManager.removeItem(at: uploadedVideosFolderURL)
    } catch {
      print("⚠️ \(#function) - \(#line)")
    }
  }
}
