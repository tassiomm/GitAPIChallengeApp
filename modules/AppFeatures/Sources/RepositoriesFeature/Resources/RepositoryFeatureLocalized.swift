//
//  RepositoryFeatureLocalized.swift
//
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import AppUI

func Localized(_ key: String, _ arg1: any CVarArg...) -> String {
    AppUI.Localized(key, bundle: Bundle.module, arg1)
}
