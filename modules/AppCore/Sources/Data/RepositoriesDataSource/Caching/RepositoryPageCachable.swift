//
//  RepositoryPageCache.swift
//  
//
//  Created by Tassio Marques on 21/02/25.
//

import Foundation
import RepositoriesAPIInterface

public protocol RepositoryPageCachable {
    func setValue(_ value: RepositoryPageCacheObject.Entry?, forKey key: String)
    func getValue(forKey key: String) -> RepositoryPageCacheObject.Entry?
}

public final class RepositoryPageCacheObject {
    public typealias Entry = RepositoriesResponseEntity
    let entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
    }
}

public final class RepositoryPageCache: RepositoryPageCachable {
    private var cacheStorage: NSCache<NSString, RepositoryPageCacheObject> = {
        var storage = NSCache<NSString, RepositoryPageCacheObject>()
        storage.totalCostLimit = 1 * 1024 * 1024 // 2MB
        return storage
    }()
    
    public init() {}
    
    public func setValue(_ value: RepositoryPageCacheObject.Entry?, forKey key: String) {
        cacheStorage[key] = value
    }
    
    public func getValue(forKey key: String) -> RepositoryPageCacheObject.Entry? {
        return cacheStorage[key]
    }
}

extension NSCache where KeyType == NSString, ObjectType == RepositoryPageCacheObject {
    subscript(_ key: String) -> RepositoryPageCacheObject.Entry? {
        get {
            let key = key as NSString
            let object = object(forKey: key)
            return object?.entry
        }
        set {
            let key = key as NSString
            if let newValue {
                let object = RepositoryPageCacheObject(entry: newValue)
                let cost = MemoryLayout.size(ofValue: object)
                setObject(object, forKey: key, cost: cost)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
