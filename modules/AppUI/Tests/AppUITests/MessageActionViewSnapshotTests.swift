//
//  MessageActionViewSnapshotTests.swift
//  
//
//  Created by Tassio Marques on 21/02/25.
//

@testable import AppUI
import SnapshotTesting
import XCTest

final class MessageActionViewSnapshotTests: XCTestCase {
    var record = true
    
    func test_messageActionView_withMessage() {
        let sut = MessageActionView(title: "Something went wrong",
                                    message: "Please, try again",
                                    buttonText: "Retry", action: {})
        
        let _ = verifySnapshot(
            of: sut,
            as: .image(layout: .fixed(width: 300, height: 150)),
            record: record
        )
    }
    
    func test_messageActionView_withoutMessage() {
        let sut = MessageActionView(title: "Something went wrong",
                                    message: nil,
                                    buttonText: "Retry", action: {})
        
        let _ = verifySnapshot(
            of: sut,
            as: .image(layout: .fixed(width: 300, height: 150)),
            record: record
        )
    }
}
