//
//  SearchRepositoryFeatureRouter.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import SwiftUI

public enum SearchRepositoryFeatureViewFactory {
    public static func entryPoint() -> some View {
        RepositoryListView(store: .init(initialState: RepositoryListFeature.State(), reducer: {
            RepositoryListFeature()
        }))
    }
}
