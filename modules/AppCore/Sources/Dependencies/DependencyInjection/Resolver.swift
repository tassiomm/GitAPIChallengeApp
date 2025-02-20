//
//  Resolver.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

/// A protocol to expose methods to resolve a dependency
public protocol Resolver {
    /// Resolve the type by parameter. Used for when the type T cannot be infered.
    /// - Parameter metaType: the type of T
    func resolve<T>(_ metaType: T.Type) -> T?

    /// Infers the type by context
    func autoResolve<T>() -> T?
}
