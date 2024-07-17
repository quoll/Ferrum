// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "numbertest",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "numbertest", targets: ["numbertest"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "numbertest",
            dependencies: [],
            path: "Sources/numbertest",
            swiftSettings: [
                .unsafeFlags(["-framework", "Metal"]),
            ]),
        .testTarget(
            name: "numbertestTests",
            dependencies: ["numbertest"],
            path: "Tests/numbertestTests")
    ]
)