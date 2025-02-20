//
//  Container.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

/// A protocol to expose methods to register a dependency
public protocol Container {
    func register<T>(instance: T, forMetaType metaType: T.Type)
    func register<T>(factory: @escaping (Resolver) -> T, forMetaType metaType: T.Type)
}

extension Container {
    /// A register for when you don't need the resolve extra dependencies of your dependency
    /// - Parameters:
    ///   - factory: the factory to instantiate T
    ///   - metaType: the type of T
    public func register<T>(factory: @escaping () -> T, forMetaType metaType: T.Type) {
        self.register(factory: { _  in factory() }, forMetaType: metaType)
    }
}
