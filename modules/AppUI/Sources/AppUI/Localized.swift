//
//  Localized.swift
//  
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation

public func Localized(_ key: String, bundle: Bundle, _ arg1: any CVarArg...) -> String {
    let string = NSLocalizedString(key, bundle: bundle, comment: "")
    return String(format: string, arg1)
}
