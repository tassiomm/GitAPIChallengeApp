//
//  PullRequestDetailFeature.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import ComposableArchitecture
import Foundation
import AppUI

@Reducer
struct PullRequestDetailsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents public var alert: AlertState<Action.Alert>?
        
        let url: URL
        var isLoading: Bool = false
    }
    
    enum Action {
        case updateIsLoading(Bool)
        case alert(PresentationAction<Alert>)
        case webViewPhase(WebView.WebViewPhase)
        case dismiss
        
        public enum Alert: Equatable, Sendable {}
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .updateIsLoading(let isLoading):
                state.isLoading = isLoading
                return .none
            case .webViewPhase(let phase):
                switch phase {
                case .didStartProvisionalNavigation:
                    state.isLoading = true
                case .didFinish:
                    state.isLoading = false
                case .didFail(let error):
                    state.isLoading = false
                    state.alert = AlertState { TextState(error.localizedDescription) }
                }
                return .none
            case .alert, .dismiss:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
