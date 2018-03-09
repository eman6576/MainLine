// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainLine",
    products: [
        .executable(
            name: "mainline",
            targets: ["MainLine"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MainLine",
            dependencies: ["MainLineCore"],
            path: "./Sources/MainLine/"
        ),
        .target(
            name: "MainLineCore",
            dependencies: [],
            path: "./Sources/MainLineCore/"
        ),
        .testTarget(
            name: "MainLineTests",
            dependencies: ["MainLineCore"]
        )
    ]
)
