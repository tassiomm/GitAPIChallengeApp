//
//  ServiceLocator.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

/// A service locator will be resposible to manage your dependencies. Stores and provide access to services or instances of dependencies
public final class ServiceLocator {
    public static let shared = ServiceLocator()

    /// Store persistent singletons
    var instances: [String: Any] = [:]
    /// Store lazy singletons. Will be deallocated when not in use
    var lazyInstances: NSMapTable<NSString, LazyInstanceWrapper> = .init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    typealias LazyDependencyFactory = () -> Any
    /// Factory that tells how to build the dependency
    var factories: [String: LazyDependencyFactory] = [:]
    
    /// Helper function to define the key of a type T
    /// - Parameter metaType: the type of T
    /// - Returns: the key string for the type T
    private func getKey<T>(for metaType: T.Type) -> String {
        return String(describing: T.self)
    }
}

extension ServiceLocator {
    /// NSMapTable will only allow class types. This wrapper allows for expanding storage for other types like structs
    final class LazyInstanceWrapper {
        let instance: Any
        init(instance: Any) {
            self.instance = instance
        }
    }
}

extension ServiceLocator {
    private func getInstance<T>(forMetaType metaType: T.Type) -> T? {
        let key = getKey(for: metaType)
        if let instance = instances[key] as? T {
            return instance
        } else if let lazyInstance = getLazyInstance(for: T.self, key: key) {
            return lazyInstance
        } else {
            return nil
        }
    }
    
    /// Ensures that using a factory stores its value as a lazy instance.
    /// - Parameters:
    ///   - : The type for T
    ///   - key: the key of the type
    /// - Returns: A instance of T or nil if not registered
    private func getLazyInstance<T>(for _: T.Type, key: String) -> T? {
        let objectKey = key as NSString
        
        /// If object is present lazyInstances, return it
        if let instanceInMemory = lazyInstances.object(forKey: objectKey)?.instance as? T {
            return instanceInMemory
        }
        
        guard let factory: LazyDependencyFactory = factories[key],
              let newInstance = factory() as? T else {
            return nil
        }
        
        let wrappedInstance = LazyInstanceWrapper(instance: newInstance)
        lazyInstances.setObject(wrappedInstance, forKey: objectKey)
        
        return newInstance
    }
}

extension ServiceLocator: Container {
    public func register<T>(instance: T, forMetaType metaType: T.Type) {
        let key = getKey(for: metaType)
        guard instances[key] == nil else {
            fatalError("Must not register a dependency twice")
        }
        instances[key] = instance
    }
    
    public func register<T>(factory: @escaping (Resolver) -> T, forMetaType metaType: T.Type) {
        let key = getKey(for: metaType)
        guard factories[key] == nil else {
            fatalError("Must not register a dependency factory twice")
        }
        factories[key] = { factory(self) }
    }
}

extension ServiceLocator: Resolver {
    public func resolve<T>(_ metaType: T.Type) -> T? {
        getInstance(forMetaType: metaType)
    }
    
    public func autoResolve<T>() -> T? {
        getInstance(forMetaType: T.self)
    }
}
