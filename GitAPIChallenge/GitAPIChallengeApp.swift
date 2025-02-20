//
//  GitAPIChallengeApp.swift
//  GitAPIChallenge
//
//  Created by Tassio Marques on 19/02/25.
//

import SwiftUI
import RepositoriesFeature

@main
struct GitAPIChallengeApp: App {
    init() {
        registerAllDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            RepositoriesFeature.entry()
        }
    }
}
