//
//  Localized.swift
//  
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation

public func Localized(_ key: String, _ arg1: any CVarArg...) -> String {
    return String(format: NSLocalizedString(key, comment: ""), arg1)
}
