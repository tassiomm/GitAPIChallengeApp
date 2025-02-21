import XCTest
import SwiftUI
@testable import AppUI
import SnapshotTesting
import UIKit
import AppFoundation

final class AvatarViewSnapshotTests: XCTestCase {
    var record = false
    
    func test_avatarView_shouldDisplayPlaceholder() {
        let sut = AvatarView(imageUrl: "", username: "username")
        
        let _ = verifySnapshot(
            of: sut,
            as: .image(layout: .fixed(width: 100, height: 100)),
            record: record
        )
    }
    
    func test_avatarView_shouldDisplayImage() {
        let url = "http://www.google.com"
        let uiImage = UIImage.imageWithColor(color: .red)
        Cache<Image>.shared.setValue(Image(uiImage: uiImage), forKey: url)
        let sut = AvatarView(imageUrl: url, username: "username")
        
        let _ = verifySnapshot(
            of: sut,
            as: .image(layout: .fixed(width: 100, height: 100)),
            record: record
        )
        
    }
}
