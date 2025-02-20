import XCTest
import SwiftUI
@testable import AppUI
import SnapshotTesting
import UIKit

final class AvatarViewSnapshotTests: XCTestCase {
    var record = true
    
    func test_avatarView_shouldDisplayPlaceholder() {
        let sut = AvatarView(imageUrl: "", username: "username")
        
        let _ = verifySnapshot(
            of: sut,
            as: .wait(for: 1, on: .image(
                precision: 1,
                layout: .fixed(
                    width: 100,
                    height: 100)
            )),
            record: record
        )
    }
    
    func test_avatarView_shouldDisplayImage() {
        let url = "http://www.google.com"
        let uiImage = UIImage.imageWithColor(color: UIColor.red)
        ImageCache.shared.setValue(Image(uiImage: uiImage), forKey: url)
        let sut = AvatarView(imageUrl: url, username: "username")
        
        let _ = verifySnapshot(
            of: sut,
            as: .wait(for: 10, on: .image(
                precision: 1,
                layout: .fixed(
                    width: 100,
                    height: 100)
            )),
            record: record
        )
        
    }
}

extension UIImage {
    public class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? .init()
    }
}
