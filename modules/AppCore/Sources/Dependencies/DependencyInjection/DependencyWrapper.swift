//
//  Dependency.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

@propertyWrapper
public final class AppDependency<T> {
    // MARK: - Dependencies
    
    private let resolver: Resolver?
    /// Failure handler ensure each dependency can manage its own way of dealing with unregistered dependencies
    private let failureHandler: (String) -> Void
    private(set) var resolvedValue: T!
    
    // MARK: - Properties
    public var wrappedValue: T {
        /// Ensures that resolved value will never be nil (as long as it was registered)
        resolveIfNeeded()
        return resolvedValue
    }
    
    public convenience init() {
        self.init(resolvedValue: nil,
                  resolver: ServiceLocator.shared,
                  failureHandler: { preconditionFailure($0) })
    }
    
    fileprivate init(resolvedValue: T?, resolver: Resolver?, failureHandler: @escaping (String) -> Void) {
        self.resolvedValue = resolvedValue
        self.resolver = resolver
        self.failureHandler = failureHandler
    }
    
    // MARK: - Private functions
    
    private func resolveIfNeeded() {
        guard resolvedValue == nil else {
            return
        }
        guard let instanceFromContainer = resolver?.resolve(T.self) else {
            failureHandler("Could not resolve \(type(of: self)). Make sure it is registered!")
            return
        }
        resolvedValue = instanceFromContainer
    }
}

#if DEBUG
extension AppDependency {
    // enable testing of @Dependency
    convenience init(resolver: Resolver, failureHandler: @escaping (String) -> Void) {
        self.init(resolvedValue: nil, resolver: resolver, failureHandler: failureHandler)
    }
    
    // allows mocking dependency - @Dependency can be injected by usage of environments
    public static func resolved(_ value: T) -> Self {
        self.init(resolvedValue: value, resolver: nil, failureHandler: { _ in })
    }
}
#endif
