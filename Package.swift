// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwURL",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwURL",
            targets: ["SwURL"]),
    ],
    targets: [
        .target(
            name: "SwURL",
            dependencies: []),
        .testTarget(
            name: "SwURLTests",
            dependencies: ["SwURL"]),
    ]
)
