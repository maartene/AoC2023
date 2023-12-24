// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day25",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "day25",
            targets: ["day25"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "day25"),
        .testTarget(
            name: "day25Tests",
            dependencies: ["day25"]),
    ]
)
