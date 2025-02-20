//
//  PullRequestDetailsView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import ComposableArchitecture
import SwiftUI
import AppUI

struct PullRequestDetailsView: View {
    @Perception.Bindable var store: StoreOf<PullRequestDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            WebView(url: store.url) { phase in
                store.send(.webViewPhase(phase))
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .overlay {
                LoadingOverlayView(isLoading: $store.isLoading.sending(\.updateIsLoading),
                                   message: "text_loading")
            }
        }
    }
}
