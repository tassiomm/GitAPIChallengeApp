//
//  ImageCachable.swift
//  AppUI
//
//  Created by Tassio Marques on 18/02/25.
//

import SwiftUI

public protocol ImageCachable {
    func setValue(_ value: ImageCacheObject.Entry?, forKey key: String)
    func getValue(forKey key: String) -> ImageCacheObject.Entry?
}

public final class ImageCacheObject {
    public typealias Entry = Image
    let entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
    }
}

public final class ImageCache: ImageCachable {
    public static let shared = ImageCache()

    private var cacheStorage = NSCache<NSString, ImageCacheObject>()
    
    public init() {}
    
    public func setValue(_ value: ImageCacheObject.Entry?, forKey key: String) {
        cacheStorage[key] = value
    }
    
    public func getValue(forKey key: String) -> ImageCacheObject.Entry? {
        return cacheStorage[key]
    }
}

extension NSCache where KeyType == NSString, ObjectType == ImageCacheObject {
    subscript(_ key: String) -> ImageCacheObject.Entry? {
        get {
            let key = key as NSString
            let object = object(forKey: key)
            return object?.entry
        }
        set {
            let key = key as NSString
            if let newValue {
                let object = ImageCacheObject(entry: newValue)
                setObject(object, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
