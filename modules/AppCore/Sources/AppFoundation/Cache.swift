//
//  Cache.swift
//  
//
//  Created by Tassio Marques on 21/02/25.
//

import Foundation

public final class CacheObject<Entry> {
    let entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
    }
}

public final class Cache<Entry> {
    private var cacheStorage: NSCache<NSString, CacheObject<Entry>>
    
    public init(storage: NSCache<NSString, CacheObject<Entry>> = .init()) {
        self.cacheStorage = storage
    }
    
    public func setValue(_ value: Entry?, forKey key: String) {
        let key = key as NSString
        if let value {
            let object = CacheObject<Entry>(entry: value)
            let cost = MemoryLayout.size(ofValue: object)
            cacheStorage.setObject(object, forKey: key, cost: cost)
        } else {
            cacheStorage.removeObject(forKey: key)
        }
    }
    
    public func getValue(forKey key: String) -> Entry? {
        let key = key as NSString
        let object = cacheStorage.object(forKey: key)
        return object?.entry
    }
}

public extension Cache {
    /// Base policy has total limit of 1MB
    static func withBasePolicy() -> Cache {
        let storage = NSCache<NSString, CacheObject<Entry>>()
        storage.totalCostLimit = 1 * 1024 * 1024
        return .init(storage: storage)
    }
    
    static func customPolicy(totalLimit: Int) -> Cache {
        let storage = NSCache<NSString, CacheObject<Entry>>()
        storage.totalCostLimit = totalLimit
        return .init(storage: storage)
    }
}
