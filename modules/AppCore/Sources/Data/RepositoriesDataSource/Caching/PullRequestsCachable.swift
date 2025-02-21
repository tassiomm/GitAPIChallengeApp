//
//  PullRequestsCache.swift
//
//
//  Created by Tassio Marques on 21/02/25.
//

import Foundation
import RepositoriesAPIInterface

public protocol PullRequestsCachable {
    func setValue(_ value: PullRequestsCacheObject.Entry?, forKey key: String)
    func getValue(forKey key: String) -> PullRequestsCacheObject.Entry?
}

public final class PullRequestsCacheObject {
    public typealias Entry = [PullRequestEntity]
    let entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
    }
}

public final class PullRequestsCache: PullRequestsCachable {
    private var cacheStorage: NSCache<NSString, PullRequestsCacheObject> = {
        var storage = NSCache<NSString, PullRequestsCacheObject>()
        storage.totalCostLimit = 1 * 1024 * 1024 // 2MB
        return storage
    }()
    
    public init() {}
    
    public func setValue(_ value: PullRequestsCacheObject.Entry?, forKey key: String) {
        cacheStorage[key] = value
    }
    
    public func getValue(forKey key: String) -> PullRequestsCacheObject.Entry? {
        return cacheStorage[key]
    }
}

extension NSCache where KeyType == NSString, ObjectType == PullRequestsCacheObject {
    subscript(_ key: String) -> PullRequestsCacheObject.Entry? {
        get {
            let key = key as NSString
            let object = object(forKey: key)
            return object?.entry
        }
        set {
            let key = key as NSString
            if let newValue {
                let object = PullRequestsCacheObject(entry: newValue)
                let cost = MemoryLayout.size(ofValue: object)
                setObject(object, forKey: key, cost: cost)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
