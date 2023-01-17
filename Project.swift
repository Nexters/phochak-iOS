import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

private enum Module: CaseIterable {
  case core
  case domain
  case network
  case service
  case designKit
  case feature

  var moduleName: String {
    switch self {
    case .core: return "Core"
    case .domain: return "Domain"
    case .network: return "Network"
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
        .target(name: Module.feature.moduleName)
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
      name: Module.network.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.core.moduleName),
        .external(name: "Moya"),
        .external(name: "RxMoya"),
        .external(name: "Alamofire")
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.service.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: [
        .target(name: Module.network.moduleName),
        .target(name: Module.domain.moduleName)
      ]),

    Project.makePhoChakFrameworkTargets(
      name: Module.designKit.moduleName,
      platform: .iOS,
      deploymentTarget: deploymentTarget,
      dependencies: []),

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
        .external(name: "SnapKit"),
        .external(name: "Then")
      ])

  ].flatMap { $0 }
)
