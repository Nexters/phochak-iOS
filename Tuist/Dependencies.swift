import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
      .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMinor(from: "15.0.0")),
      .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .upToNextMajor(from: "2.8.0")),
      .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMinor(from: "3.2.0")),
      .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0")),
      .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .upToNextMajor(from: "5.0.0")),
      .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMinor(from: "2.7.0")),
      .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
      .remote(url: "https://github.com/kakao/kakao-ios-sdk-rx.git", requirement: .upToNextMajor(from: "2.0.0")),
      .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
      .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "4.1.0"))
    ]
  ),
  platforms: [.iOS]
)
