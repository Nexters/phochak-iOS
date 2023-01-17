//
//  MockClass.swift
//  CoreTests
//
//  Created by 한상진 on 2023/01/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

final class MockClass {
  private let mockDependency: MockDependencyType

  init(mockDependency: MockDependencyType) {
    self.mockDependency = mockDependency
  }

  func stub() -> Int {
    return mockDependency.stubNumber
  }
}
