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
    dependencies: [
        .swiftSnapshotTesting
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppUI"
        ),
        
        .testTarget(
            name: "AppUITests",
            dependencies: [
                "AppUI",
                .snapshotTesting
            ],
            exclude: ["__Snapshots__"]
        ),
    ]
)

extension PackageDescription.Target.Dependency {
    static let snapshotTesting: Self = .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
}

extension PackageDescription.Package.Dependency {
    static let swiftSnapshotTesting: Package.Dependency =
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.0")
}
