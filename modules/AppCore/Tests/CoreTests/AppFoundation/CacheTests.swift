//
//  CacheTests.swift
//  
//
//  Created by Tassio Marques on 21/02/25.
//

import XCTest
@testable import AppFoundation

final class CacheTests: XCTestCase {
    
    func test_cache_expectNoValue() {
        let sut = Cache<String>.withBasePolicy()
        
        XCTAssertNil(sut.getValue(forKey: "1"))
        XCTAssertNil(sut.getValue(forKey: "2"))
    }
    
    func test_cache_expectToStoredValue() {
        let cacheStorage = NSCache<NSString, CacheObject<String>>()
        let sut = Cache<String>(storage: cacheStorage)
        
        sut.setValue("abc", forKey: "1")
        
        XCTAssertEqual(cacheStorage.object(forKey: "1")?.entry, "abc")
    }
    
    func test_cache_expectReplacedValue() {
        let cacheStorage = NSCache<NSString, CacheObject<String>>()
        let sut = Cache<String>(storage: cacheStorage)
        
        cacheStorage.setObject(.init(entry: "abc"), forKey: "1")
        XCTAssertEqual(sut.getValue(forKey: "1"), "abc")
        
        sut.setValue("def", forKey: "1")
        XCTAssertEqual(cacheStorage.object(forKey: "1")?.entry, "def")
    }
    
    func test_cache_expectValueReplacedByNil() {
        let cacheStorage = NSCache<NSString, CacheObject<String>>()
        let sut = Cache<String>(storage: cacheStorage)
        
        sut.setValue("abc", forKey: "1")
        XCTAssertEqual(cacheStorage.object(forKey: "1")?.entry, "abc")
        
        sut.setValue(nil, forKey: "1")
        XCTAssertNil(cacheStorage.object(forKey: "1")?.entry, "def")
    }
}
