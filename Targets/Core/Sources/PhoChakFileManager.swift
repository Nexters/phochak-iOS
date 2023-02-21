//
//  PhoChakFileManager.swift
//  Core
//
//  Created by 한상진 on 2023/02/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public enum PhoChakFileManager {

  // MARK: Properties
  private static let uploadedVideosFolderURL = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )[0].appendingPathComponent("UploadedVideos")

  // MARK: Methods
  public static func saveVideo(name: String, data: Data) {
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

    let path = uploadedVideosFolderURL.appendingPathComponent(name)

    DispatchQueue.global().async {
      do {
        try data.write(to: path, options: .atomic)
      } catch {
        print("⚠️ \(#function) - \(#line)")
      }
    }
  }

  public static func fetchVideoURLString(name: String) -> String {
    return "\(uploadedVideosFolderURL.path)/\(name)"
  }

  public static func removeUploadedVideos() {
    do {
      try FileManager.default.removeItem(at: uploadedVideosFolderURL)
    } catch {
      print("⚠️ \(#function) - \(#line)")
    }
  }
}
