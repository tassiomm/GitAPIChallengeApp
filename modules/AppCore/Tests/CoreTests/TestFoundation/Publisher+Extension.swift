//
//  Publisher+extension.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Combine
import XCTest

extension Publisher {
    /// A util sink function to observe emissions in a publisher and handle the appropriate path expected by implementing the closure call.
    /// It's only need to define the closure paht that you expect to happen on you test case. The fuction will call XCTFail and fail the test
    /// if an unexpected path happened. This either means your test parameters are not what you intenteded or you didn't implement
    /// the path you expect to happen.
    ///
    /// - Parameters:
    ///   - onFailure: closure that will be executed if publisher emits error
    ///   - onFinished: closure that will be executed when Publisher finishes life cyclie of emissions.
    ///   - onReceiveValue: closure that will be executed when Publisher emits a value
    /// - Returns: a cancellable subscribtion
    public func sink(onFailure: ((Self.Failure) -> Void)? = nil,
                     onFinished: (() -> Void)? = nil,
                     onReceiveValue: ((Self.Output) -> Void)? = nil,
                     file: StaticString = #file,line: UInt = #line) -> AnyCancellable {
        sink { status in
            switch status {
            case .failure(let error):
                if let onFailure = onFailure {
                    onFailure(error)
                } else {
                    XCTFail(
                        "Publisher is not expected to fail or onFailure should be handled - \n got \(error.localizedDescription)",
                        file: file, line: line)
                }
            case .finished:
                onFinished?()
                break
            }
        } receiveValue: { value in
            if let onReceive = onReceiveValue {
                onReceive(value)
            } else {
                XCTFail("Publisher is not expected to succeed or onReceiveValue should be handled", file: file, line: line)
            }
        }
    }
    
    public func expects(receiveValue: @escaping ((Self.Output) -> Void),
                 file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
        sink(onReceiveValue: receiveValue, file: file, line: line)
    }
    
    public func expects(failure: @escaping ((Self.Failure) -> Void),
                 file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
        sink(onFailure: failure, file: file, line: line)
    }
}
