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
//        .swiftCollections,
//        .swiftIdentifiedCollections,
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
            type: .static,
            targets: [
                "SearchRepoFeature"
            ]
        )
    ]
}

enum Targets {
    static func all() -> [Target] {
        searchRepoFeatureTargets
//        + dummyTargets
    }
    
    // MARK: - Breeds Listing Feature Targets
    private static let searchRepoFeatureTargets: [Target] = [
        .target(
            name: "SearchRepoFeature",
            dependencies:
            [
                .appUI,
                .tca
            ],
            path: "Sources/SearchRepoFeature"
        )
    ]
    
    /// Fake Target used for satisfying dependencies imports not used directly by package
    /// The dependencies bellow needed to be fixed at a certain version to satisfy swift-composable-architecture needs
    private static let dummyTargets: [Target] = [
        .target(name: "Dummy",
                dependencies: [
                    .swiftCollections,
                    .swiftIdentifiedCollections
                ],
                path: "Sources/Dummy")
    ]
}

// MARK: - Packages

extension Package.Dependency {
    // MARK: Internal
    static let appUILibrary: Package.Dependency = .package(name: "AppUI", path: "../AppUI")
    
    // tca
    static let swiftCollections: Package.Dependency = .package(url: "https://github.com/apple/swift-collections.git", exact: "1.1.0")
    static let swiftIdentifiedCollections: Package.Dependency =
        .package(url: "https://github.com/pointfreeco/swift-identified-collections.git", exact: "1.1.0")
    static let swiftTCA: Package.Dependency =
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.17.0")
}

// MARK: - Products

extension PackageDescription.Target.Dependency {
    // MARK: Local
    static let appUI: Self = .product(name: "AppUI", package: "AppUI")
//    static let dependencyInjection: Self = .product(name: "DependencyInjection", package: "AppCore")
    
    // tca
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    // these libraries are imported for fixing the version, but aren't used directly by the package.
    static let swiftCollections: Self = .product(name: "Collections", package: "swift-collections")
    static let swiftIdentifiedCollections: Self = .product(name: "IdentifiedCollections", package: "swift-identified-collections")
}


