//
//  TokenManager.swift
//  Core
//
//  Created by 한상진 on 2023/01/31.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation
import Security

public enum TokenManager {

  // MARK: Properties
  public enum TokenType: String, CaseIterable {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
  }

  // MARK: Methods
  public static func save(tokenType: TokenType, data: Data) {
    let query: NSDictionary = .init(
      dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: tokenType.rawValue,
        kSecValueData: data
      ]
    )

    SecItemDelete(query)
    SecItemAdd(query, nil)
  }

  public static func load(tokenType: TokenType) -> Data? {
    let query: NSDictionary = .init(
      dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: tokenType.rawValue,
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

  public static func deleteAll() {
    TokenType.allCases.forEach {
      let query: NSDictionary = .init(dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: $0.rawValue
      ])

      SecItemDelete(query)
    }
  }
}
