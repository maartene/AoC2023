// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day24",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "day24",
            targets: ["day24"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "day24"),
        .testTarget(
            name: "day24Tests",
            dependencies: ["day24"]),
    ]
)
