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
    
    // tca
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}


