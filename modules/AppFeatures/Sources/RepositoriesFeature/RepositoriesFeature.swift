//
//  SearchRepositoryFeatureRouter.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import SwiftUI
import ComposableArchitecture

public enum RepositoriesFeature {
    public static func entry() -> some View {
        RepositoryListView(
            store: Store(initialState: RepositoryListFeature.State(language: "Swift")) {
              RepositoryListFeature()
          }
        )
    }
}
