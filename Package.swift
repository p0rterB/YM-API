// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "YMAPI",
    platforms: [
        .macOS(.v10_12), .macCatalyst(.v13), .iOS(.v10), .tvOS(.v10), .watchOS(.v3), .visionOS(.v1)
    ],
    products: [
        .library(name: "YMAPI", targets: ["YMAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "YMAPI", dependencies: [], resources: [.copy("PrivacyInfo.xcprivacy")]),
        .testTarget(name: "YMTests", dependencies: ["YMAPI"], exclude: ["TestCredentialsTemplate.swift"])
    ],
    swiftLanguageVersions: [.v5]
)
