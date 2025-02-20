// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// This package defines the App UI Components
let package = Package(
    name: "AppUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppUI",
            targets: ["AppUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppUI"),
        .testTarget(
            name: "AppUITests",
            dependencies: ["AppUI"]
        ),
    ]
)
