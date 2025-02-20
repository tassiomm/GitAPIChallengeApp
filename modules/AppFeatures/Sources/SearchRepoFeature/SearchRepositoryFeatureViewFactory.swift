//
//  SearchRepositoryFeatureRouter.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import SwiftUI
import ComposableArchitecture

public enum SearchRepositoryFeatureViewFactory {
    public static func repositoriesView() -> some View {
        RepositoryListView(
            store: Store(initialState: RepositoryListFeature.State()) {
              RepositoryListFeature()
          }
        )
    }
}
