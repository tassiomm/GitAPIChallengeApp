//
//  File.swift
//  
//
//  Created by Tassio Marques on 21/02/25.
//

import UIKit
import SwiftUI

extension UIImage {
    public static func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? .init()
    }
}

extension Image {
    public static func imageWithColor(color: UIColor) -> Image {
        let uiImage = UIImage.imageWithColor(color: color)
        return Image(uiImage: uiImage)
    }
}
