// swift-tools-version:5.3

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
            targets: [
                "SwURL"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "SwURL",
            dependencies: []
        ),
        .testTarget(
            name: "SwURLTests",
            dependencies: [
                "SwURL"
            ]
        ),
    ]
)
