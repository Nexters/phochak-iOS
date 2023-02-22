//
//  PhoChakFileManager.swift
//  Core
//
//  Created by 한상진 on 2023/02/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public protocol PhoChakFileManagerType {

  // MARK: Properties
  var uploadedVideosFolderURL: URL { get }

  // MARK: Methods
  func saveVideo(name: String, data: Data)
  func fetchVideoURLString(name: String) -> String
  func removeUploadedVideos()
}

public final class PhoChakFileManager: PhoChakFileManagerType {

  // MARK: Properties
  public var uploadedVideosFolderURL: URL {
    FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    )[0].appendingPathComponent("UploadedVideos")
  }

  // MARK: Methods
  public func saveVideo(name: String, data: Data) {
    if !FileManager.default.fileExists(atPath: uploadedVideosFolderURL.path) {
      do {
        try FileManager.default.createDirectory(
          atPath: uploadedVideosFolderURL.path,
          withIntermediateDirectories: true,
          attributes: nil
        )
      } catch {
        print("⚠️ \(#function) - \(#line)")
      }
    }

    let videoPath = uploadedVideosFolderURL.appendingPathComponent(name)
    guard !FileManager.default.fileExists(atPath: videoPath.path) else { return }

    DispatchQueue.global().async {
      do {
        try data.write(to: videoPath, options: .atomic)
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
      try FileManager.default.removeItem(at: uploadedVideosFolderURL)
    } catch {
      print("⚠️ \(#function) - \(#line)")
    }
  }

  // MARK: Initializer
  public init() {}
}
