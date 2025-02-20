// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// This package defines the core of the applicaiton, like networking dependency and DI System
let package = Package(
    name: "AppCore",
    platforms: [
        .iOS(.v16)
    ],
    products: Products.all(),
    dependencies: [
        .cwlPreconditionTesting
    ],
    targets: Targets.all()
)

// MARK: - PRODUCTS

enum Products {
    static func all() -> [Product] {
        coreInterfaces
        + coreProducts
    }
    
    private static let coreInterfaces: [Product] = [
        .library(name: "AppCoreInterface",
                 targets: [
                    "NetworkingInterface"
                 ])
    ]
    
    private static let coreProducts: [Product] = [
        .library(
            name: "AppCore",
            targets: [
                "DependencyInjection",
                "Networking",
            ])
    ]
}

// MARK: - TARGETS

enum Targets {
    static func all() -> [Target] {
        dependenciesTargets
    }
    
    private static let dependenciesTargets: [Target] = [
        // MARK: - DI Targets
        
        .target(name: "DependencyInjection",
                dependencies: [],
                path: "Sources/Dependencies/DependencyInjection"),
        
        // MARK: - Networking Targets
        
            .target(name: "NetworkingInterface",
                dependencies: [],
                path: "Sources/Dependencies/NetworkingInterface"),
        .target(name: "Networking",
                dependencies: [
                    .networkingInterface,
                ],
                path: "Sources/Dependencies/Networking"),
        
        .testTarget(
            name: "AppCoreTests",
            dependencies: [
                .networkingInterface,
                .networking,
                .dependencyInjection,
                .cwlPreconditionTesting
            ],
            path: "Tests/CoreTests"
        ),
    ]
}

// MARK: - Dependencies

extension PackageDescription.Target.Dependency {
    // interfaces
    static let networkingInterface: Self = .byName(name: "NetworkingInterface")
    
    // internal
    static let networking: Self = .byName(name: "Networking")
    static let dependencyInjection: Self = .byName(name: "DependencyInjection")
    
    // testing
    static let cwlPreconditionTesting: Self = .product(name: "CwlPreconditionTesting", package: "CwlPreconditionTesting")
}

extension PackageDescription.Package.Dependency {
    static let cwlPreconditionTesting: Package.Dependency =
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting", .upToNextMajor(from: "2.1.0"))
}
