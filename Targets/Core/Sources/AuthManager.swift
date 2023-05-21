//
//  AuthManager.swift
//  Core
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation
import Security

public enum AuthManager {

  // MARK: Properties
  public enum AuthInfoType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case isFirstSignIn = "isFirstSignIn"
  }

  // MARK: Methods
  public static func save(authInfoType: AuthInfoType, data: Data) {
    let query: NSDictionary = .init(
      dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: authInfoType.rawValue,
        kSecValueData: data
      ]
    )

    SecItemDelete(query)
    SecItemAdd(query, nil)
  }

  public static func load(authInfoType: AuthInfoType) -> Data? {
    let query: NSDictionary = .init(
      dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: authInfoType.rawValue,
        kSecReturnData: true,
        kSecMatchLimit: kSecMatchLimitOne
      ]
    )

    var dataTypeReference: AnyObject?
    let status = withUnsafeMutablePointer(to: &dataTypeReference) {
      SecItemCopyMatching(query, UnsafeMutablePointer($0))
    }

    guard status == errSecSuccess,
          let data = dataTypeReference as? Data
    else { return nil }

    return data
  }

  public static func deleteTokens() {
    [AuthInfoType.accessToken, AuthInfoType.refreshToken].forEach {
      let query: NSDictionary = .init(dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: $0.rawValue
      ])

      SecItemDelete(query)
    }
  }
}
