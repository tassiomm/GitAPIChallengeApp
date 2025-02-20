//
//  IconTextViewSnapshotTests.swift
//
//
//  Created by Tassio Marques on 20/02/25.
//

import AppUI
import XCTest
import SnapshotTesting
import SwiftUI

final class IconTextViewSnapshotTests: XCTestCase {
    var record = false
    
    func test_IconText_displayWithImage() {
        let sut = IconTextView(icon: .imageWithColor(color: .red),
                               text: "The icon is red",
                               textColor: .red)
        
        let _ = verifySnapshot(
            of: sut,
            as: .image(layout: .fixed(width: 100, height: 100)),
            record: record
        )
    }
}
