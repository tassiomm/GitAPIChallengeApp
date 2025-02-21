// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFeatures",
    platforms: [
        .iOS(.v16)
    ],
    products: Products.all(),
    dependencies: [
        .appUILibrary,
        .appCorePackage,
        .swiftTCA
    ],
    targets: Targets.all()
)

enum Products {
    static func all() -> [Product] {
        featureProducts
    }
    
    private static let featureProducts: [Product] = [
        .library(
            name: "AppFeatures",
            targets: [
                "RepositoriesFeature"
            ]
        )
    ]
}

enum Targets {
    static func all() -> [Target] {
        repositoriesFeatureTargets
    }
    
    private static let repositoriesFeatureTargets: [Target] = [
        .target(
            name: "RepositoriesFeature",
            dependencies:
                [
                    .appUI,
                    .tca,
                    .appCoreInterfaces
                ],
            path: "Sources/RepositoriesFeature"
        ),
        
        .testTarget(
            name: "AppFeaturesTests",
            dependencies: [
                    //"RepositoriesFeature",
                    //.tca
            ],
            path: "Tests/AppFeaturesTests"
        )
    ]
}

// MARK: - Packages

extension Package.Dependency {
    // MARK: Internal
    static let appUILibrary: Package.Dependency = .package(name: "AppUI", path: "../AppUI")
    static let appCorePackage: Package.Dependency = .package(name: "AppCore", path: "../AppCore")
    
    // tca
    static let swiftTCA: Package.Dependency =
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.17.0")
}

// MARK: - Products

extension PackageDescription.Target.Dependency {
    // MARK: Local
    static let appUI: Self = .product(name: "AppUI", package: "AppUI")
    static let appCoreInterfaces: Self = .product(name: "AppCoreInterface", package: "AppCore")
    
    // tca
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}


