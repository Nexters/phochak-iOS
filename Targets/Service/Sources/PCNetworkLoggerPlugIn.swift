//
//  PCNetworkLoggerPlugIn.swift
//  Service
//
//  Created by Ian on 2023/02/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//
import Foundation

import RxMoya
import Moya

public struct PCNetworkLoggerPlugin: PluginType {
  public func willSend(_ request: RequestType, target: TargetType) {
    #if DEBUG
    guard let request = request.request,
          let method = request.method else { return }

    let methodRawValue = method.rawValue
    let requestDescription = request.debugDescription
    let headers = String(describing: target.headers)

    let message = """
    [Moya-Logger] - @\(methodRawValue): \(requestDescription)
    [Moya-Logger] headers: \(headers)
    \n
    """
    print(message)
    #endif
  }

  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    #if DEBUG
    print("[Moya-Logger] - \(target.baseURL)\(target.path)")

    switch result {
    case .success(let response):
      guard let jsonData = try? JSONSerialization.data(withJSONObject: response.mapJSON(), options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8) else { return }

      print("[Moya-Logger] Success: \(jsonString)")
    case .failure(let error):
      print("[Moya-Logger] Fail: \(String(describing: error.errorDescription))")
    }
    #endif
  }
}

