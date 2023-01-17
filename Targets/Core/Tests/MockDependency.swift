//
//  MockDependency.swift
//  CoreTests
//
//  Created by 한상진 on 2023/01/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

protocol MockDependencyType {

  // MARK: Properties
  var stubNumber: Int { get }
}

final class MockDependency: MockDependencyType {

  // MARK: Properties
  var stubNumber: Int = 200
}
