// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum PhoChakAsset {
  public static let blue100 = PhoChakColors(name: "blue-100")
  public static let blue200 = PhoChakColors(name: "blue-200")
  public static let blue300 = PhoChakColors(name: "blue-300")
  public static let blue400 = PhoChakColors(name: "blue-400")
  public static let blue500 = PhoChakColors(name: "blue-500")
  public static let blue600 = PhoChakColors(name: "blue-600")
  public static let blue700 = PhoChakColors(name: "blue-700")
  public static let blue800 = PhoChakColors(name: "blue-800")
  public static let blue900 = PhoChakColors(name: "blue-900")
  public static let green100 = PhoChakColors(name: "green-100")
  public static let green200 = PhoChakColors(name: "green-200")
  public static let green300 = PhoChakColors(name: "green-300")
  public static let green400 = PhoChakColors(name: "green-400")
  public static let green500 = PhoChakColors(name: "green-500")
  public static let green600 = PhoChakColors(name: "green-600")
  public static let green700 = PhoChakColors(name: "green-700")
  public static let green800 = PhoChakColors(name: "green-800")
  public static let green900 = PhoChakColors(name: "green-900")
  public static let monoGray100 = PhoChakColors(name: "mono-gray-100")
  public static let monoGray200 = PhoChakColors(name: "mono-gray-200")
  public static let monoGray300 = PhoChakColors(name: "mono-gray-300")
  public static let monoGray400 = PhoChakColors(name: "mono-gray-400")
  public static let monoGray50 = PhoChakColors(name: "mono-gray-50")
  public static let monoGray500 = PhoChakColors(name: "mono-gray-500")
  public static let monoGray600 = PhoChakColors(name: "mono-gray-600")
  public static let monoGray700 = PhoChakColors(name: "mono-gray-700")
  public static let monoGray800 = PhoChakColors(name: "mono-gray-800")
  public static let monoGray900 = PhoChakColors(name: "mono-gray-900")
  public static let monoGray950 = PhoChakColors(name: "mono-gray-950")
  public static let red100 = PhoChakColors(name: "red-100")
  public static let red200 = PhoChakColors(name: "red-200")
  public static let red300 = PhoChakColors(name: "red-300")
  public static let red400 = PhoChakColors(name: "red-400")
  public static let red500 = PhoChakColors(name: "red-500")
  public static let red600 = PhoChakColors(name: "red-600")
  public static let red700 = PhoChakColors(name: "red-700")
  public static let red800 = PhoChakColors(name: "red-800")
  public static let red900 = PhoChakColors(name: "red-900")
  public static let yellow100 = PhoChakColors(name: "yellow-100")
  public static let yellow200 = PhoChakColors(name: "yellow-200")
  public static let yellow300 = PhoChakColors(name: "yellow-300")
  public static let yellow400 = PhoChakColors(name: "yellow-400")
  public static let yellow500 = PhoChakColors(name: "yellow-500")
  public static let yellow600 = PhoChakColors(name: "yellow-600")
  public static let yellow700 = PhoChakColors(name: "yellow-700")
  public static let yellow800 = PhoChakColors(name: "yellow-800")
  public static let yellow900 = PhoChakColors(name: "yellow-900")
  public static let back = PhoChakImages(name: "back")
  public static let dots = PhoChakImages(name: "dots")
  public static let exclame = PhoChakImages(name: "exclame")
  public static let filter = PhoChakImages(name: "filter")
  public static let heart = PhoChakImages(name: "heart")
  public static let iconX = PhoChakImages(name: "iconX")
  public static let kakao = PhoChakImages(name: "kakao")
  public static let search = PhoChakImages(name: "search")
  public static let setting = PhoChakImages(name: "setting")
  public static let tabHome = PhoChakImages(name: "tab_home")
  public static let tabHomeSelected = PhoChakImages(name: "tab_home_selected")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class PhoChakColors {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension PhoChakColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: PhoChakColors) {
    let bundle = PhoChakResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
public extension SwiftUI.Color {
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  init(asset: PhoChakColors) {
    let bundle = PhoChakResources.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct PhoChakImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = PhoChakResources.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension PhoChakImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the PhoChakImages.image property")
  convenience init?(asset: PhoChakImages) {
    #if os(iOS) || os(tvOS)
    let bundle = PhoChakResources.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: PhoChakImages) {
    let bundle = PhoChakResources.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: PhoChakImages, label: Text) {
    let bundle = PhoChakResources.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: PhoChakImages) {
    let bundle = PhoChakResources.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
