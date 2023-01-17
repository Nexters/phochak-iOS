//
//  DIContainerTests.swift
//  CoreTests
//
//  Created by 한상진 on 2023/01/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import XCTest

import Swinject

final class DIContainerTests: XCTestCase {

  // MARK: Properties
  private let container: Container = .init()

  // MARK: Methods
  override func setUp() {
    super.setUp()
    register()
  }

  override func tearDown() {
    super.tearDown()
    container.removeAll()
  }

  func test_whenCallStubMethod_thenReturn200() {
    guard let mockClass = container.resolve(MockClass.self) else { fatalError() }

    XCTAssertEqual(mockClass.stub(), 500)
    XCTAssertEqual(mockClass.stub(), 200)
  }
}

// MARK: - Extension
private extension DIContainerTests {
  func register() {
    container.register(MockDependencyType.self) { _ in MockDependency() }

    container.register(MockClass.self) {
      guard let dependency = $0.resolve(MockDependencyType.self) else { fatalError() }

      return MockClass(mockDependency: dependency)
    }
  }
}
