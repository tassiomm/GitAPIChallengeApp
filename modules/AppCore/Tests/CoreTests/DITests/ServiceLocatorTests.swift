//
//  ServiceLocatorTests.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import XCTest
import CwlPreconditionTesting
@testable import DependencyInjection

final class ServiceLocatorTests: XCTestCase {
    func test_registerInstance_expectsValueToBeRegistered() throws {
        let sut = ServiceLocator()
        sut.register(instance: "value", forMetaType: String.self)
        let key = String(describing: String.self)
        let registeredValue = try XCTUnwrap(sut.instances[key] as? String)
        XCTAssertEqual(registeredValue, "value")
    }
    
    func test_registerInstance_expectsValueToNil() throws {
        let sut = ServiceLocator()
        let key = String(describing: String.self)
        XCTAssertNil(sut.instances[key])
    }
    
    func test_registerInstance_expectsFatalError() {
        let sut = ServiceLocator()
        // register once
        sut.register(instance: "value", forMetaType: String.self)
        
        let badInstruction = catchBadInstruction {
            // tries to register twice, should get fatal Error
            sut.register(instance: "new value", forMetaType: String.self)
        }
        XCTAssertNotNil(badInstruction, "Expected Fatal Error to be caught")
    }
    
    func test_registerFactory_expectsToBeRegistered() throws {
        let sut = ServiceLocator()
        // register once
        sut.register(factory: { _ in "value" }, forMetaType: String.self)
        let key = String(describing: String.self)
        let registeredFactory = try XCTUnwrap(sut.factories[key])
        XCTAssertEqual(registeredFactory() as? String, "value")
    }
    
    func test_registerFactory_expectsFactoryToBeNil() throws {
        let sut = ServiceLocator()
        let key = String(describing: String.self)
        XCTAssertNil(sut.factories[key])
    }
    
    func test_registerFactory_expectsFatalError() {
        let sut = ServiceLocator()
        // register once
        sut.register(factory: { _ in "value" }, forMetaType: String.self)
        
        let badInstruction = catchBadInstruction {
            // tries to register twice, should get fatal Error
            sut.register(factory: { _ in "new value" }, forMetaType: String.self)
        }
        XCTAssertNotNil(badInstruction, "Expected Fatal Error to be caught")
    }
    
    func test_resolveType_expectsResolvingValueSuccesfull() throws {
        let sut = ServiceLocator()
        sut.register(instance: "my registered value", forMetaType: String.self)
        let registeredValue = try XCTUnwrap(sut.resolve(String.self))
        XCTAssertEqual(registeredValue, "my registered value")
    }
    
    func test_resolveType_expectsResolvingReturnsNil() throws {
        let sut = ServiceLocator()
        XCTAssertNil(sut.resolve(String.self))
    }
    
    func test_autoResolveType_expectsResolvingValueSuccesfull() throws {
        let sut = ServiceLocator()
        sut.register(instance: "my registered value", forMetaType: String.self)
        let registeredValue: String = try XCTUnwrap(sut.autoResolve())
        XCTAssertEqual(registeredValue, "my registered value")
    }
    
    func test_autoResolveType_expectsResolvingReturnsNil() throws {
        let sut = ServiceLocator()
        let registeredValue: String? = sut.autoResolve()
        XCTAssertNil(registeredValue)
    }
    
    func test_resolveFactory_resolvesTwice_expectsToReturnDifferentInstances() {
        class TestObject {}
        let sut = ServiceLocator()
        // register once
        sut.register(factory: { _ in TestObject() }, forMetaType: TestObject.self)
        
        // get result
        let firstResult = sut.resolve(TestObject.self)
        let secondResult = sut.resolve(TestObject.self)
        
        // expect factory to build a new object
        XCTAssertTrue(firstResult !== secondResult)
    }
}
