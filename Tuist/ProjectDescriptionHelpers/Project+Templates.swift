import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }

  public static func makePhoChakFrameworkTargets(
    name: String,
    platform: Platform,
    deploymentTarget: DeploymentTarget,
    dependencies: [TargetDependency]
  ) -> [Target] {
    let sources = Target(
      name: name,
      platform: platform,
      product: .framework,
      bundleId: "com.ian.\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Targets/\(name)/Sources/**"],
      resources: [],
      dependencies: dependencies,
      settings: .settings(base: .init())
    )

    let tests = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "com.ian.\(name)Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Targets/\(name)/Tests/**"],
      resources: [],
      dependencies: [
        .target(name: name)
      ]
    )

    return [sources, tests]
  }

  public static func makePhoChakAppTarget(
    platform: Platform,
    dependencies: [TargetDependency],
    deploymentTarget: DeploymentTarget
  ) -> Target {
    let platform = platform
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0",
      "CFBundleVersion": "1",
      "CFBundleDisplayName": "$(PRODUCT_NAME)",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIUserInterfaceStyle": "Dark",
      "CFBundleURLTypes": [
        [
          "CFBundleTypeRole": "Editor",
          "CFBundleURLSchemes": ["kakao${KAKAO_NATIVE_APP_KEY}"]
        ]
      ],
      "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
      "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
      "BASE_URL": "${BASE_URL}",
      "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
      "NSPhotoLibraryAddUsageDescription": "사진첩 접근 권한 요청",
      "UIApplicationSupportsIndirectInputEvents": true,
      "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
          "UIWindowSceneSessionRoleApplication": [
            [
              "UISceneConfigurationName": "Default Configuration",
              "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
            ],
          ]
        ]
      ],
      "UIAppFonts": [
        "Pretendard-Bold.otf",
        "Pretendard-ExtraBold.otf",
        "Pretendard-Light.otf",
        "Pretendard-Medium.otf",
        "Pretendard-Regular.otf",
        "Pretendard-SemiBold.otf"
      ],
      "UIFileSharingEnabled": true,
      "LSSupportsOpeningDocumentsInPlace": true
    ]

    return .init(
      name: "PhoChak",
      platform: platform,
      product: .app,
      bundleId: "com.ian.PhoChak",
      deploymentTarget: deploymentTarget,
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Targets/PhoChak/Sources/**"],
      resources: ["Targets/PhoChak/Resources/**"],
      entitlements: "./Phochak.entitlements",
      dependencies: dependencies,
      settings: .settings(base: .init()
        .automaticCodeSigning(devTeam: "857J3M5L6B")
      )
    )
  }
}
