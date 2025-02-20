//
//  DependencyTests.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import XCTest
import CwlPreconditionTesting
@testable import DependencyInjection

final class DependencyWrapperTests: XCTestCase {
    func test_initializeNewDependencyNotRegistered_expectsWrappedValueToFail() {
        let depedency = AppDependency<String>()
        let badInstruction = catchBadInstruction {
            _ = depedency.wrappedValue
        }
        XCTAssertNotNil(badInstruction, "Expected to catch fatal error")
    }
    
    func test_initializeNewDependencyRegistered_expectsValueToBeReturned() {
        let depedency = AppDependency<String>(resolver: ResolverStub(result: { "my registered value" }),
                                              failureHandler: { _ in })
        XCTAssertEqual(depedency.wrappedValue, "my registered value")
    }
    
    func test_initializeNewDependency_retrieveValueTwice_expectsToBeResolvedOnlyOnce() {
        class TestObject {}
        let depedency = AppDependency<TestObject>(resolver: ResolverStub(result: { TestObject() }),
                                                  failureHandler: { _ in })
        let firstResolvedValue = depedency.wrappedValue
        let secondResolvedValue = depedency.wrappedValue
        XCTAssert(firstResolvedValue === secondResolvedValue)
    }
}
