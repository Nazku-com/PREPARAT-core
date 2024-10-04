// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PREPARAT-core",
    platforms: [.macOS(.v13), .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PREPARAT-core",
            targets: ["PREPARAT-core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/scinfu/SwiftSoup", .upToNextMajor(from: "2.7.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PREPARAT-core",
            dependencies: ["Alamofire", "SwiftSoup"]
        ),
        .testTarget(
            name: "PREPARAT-coreTests",
            dependencies: ["PREPARAT-core"]),
    ]
)
