import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

private enum Module: CaseIterable {
  case core
  case domain
  case service
  case designKit
  case feature

  var moduleName: String {
    switch self {
    case .core: return "Core"
    case .domain: return "Domain"
    case .service: return "Service"
    case .designKit: return "DesignKit"
    case .feature: return "Feature"
    }
  }
}

private let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone])

func makeConfig() -> Settings {
  Settings.settings(configurations: [
    .debug(
      name: "Debug",
      xcconfig: .relativeToRoot("Targets/PhoChak/Config/Debug.xcconfig")
    ),
    .release(
      name: "Release",
      xcconfig: .relativeToRoot("Targets/PhoChak/Config/Release.xcconfig")
    )
  ])
}

let project: Project = .init(
  name: "PhoChak",
  organizationName: "PhoChak",
  settings: makeConfig(),
  targets: [
    [Project.makePhoChakAppTarget(
      platform: .iOS,
      dependencies: [
        .target(name: Module.feature.moduleName),
        .target(name: Module.service.moduleName)
      ],
      deploymentTarget: deploymentTarget)],

    Project.makePhoChakFrameworkTargets(
      name: Module.core.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .external(name: "Swinject"),
        .external(name: "RxSwift"),
        .external(name: "RxRelay")
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.domain.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.core.moduleName)
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.service.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.domain.moduleName),
        .external(name: "Moya"),
        .external(name: "RxMoya"),
        .external(name: "RxKakaoSDK")
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.designKit.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.domain.moduleName),
        .external(name: "RxCocoa"),
        .external(name: "RxSwift")
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.feature.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.designKit.moduleName),
        .target(name: Module.domain.moduleName),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "ReactorKit"),
        .external(name: "Kingfisher"),
        .external(name: "SnapKit"),
        .external(name: "Then")
      ])
  ].flatMap { $0 }
)
