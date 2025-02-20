//
//  PullRequestsListView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//


import ComposableArchitecture
import SwiftUI
import AppUI

struct PullRequestsListView: View {
    @Perception.Bindable var store: StoreOf<PullRequestsListFeature>
    
    enum Layout {
        static let rowVerticalInsets = 8.0
        static let rowHorizontalInsets = 15.0
        static let imageSide = 40.0
    }
    
    var body: some View {
        WithPerceptionTracking {
            List(store.pullRequests) { pullRequest in
                VStack(alignment: .leading) {
                    Text(pullRequest.title)
                        .font(.title3)
                        .foregroundStyle(Color.blue)
                        .bold()
                    Text(pullRequest.body)
                        .font(.body)
                        .foregroundStyle(Color.gray)
                        .lineLimit(4)
                    
                    Spacer().frame(height: 10)
                    
                    UserAvatarView(model: .init(avatarUrl: pullRequest.user.avatar_url,
                                                author: pullRequest.user.login))
                        .frame(height: 65)
                }
                .listRowInsets(.init(top: Layout.rowVerticalInsets,
                                     leading:  Layout.rowHorizontalInsets,
                                     bottom:  Layout.rowVerticalInsets,
                                     trailing:  Layout.rowHorizontalInsets))
                .onTapGesture {
                    store.send(.showPullRequestDetails(url: pullRequest.html_url))
                }
            }
            .navigationTitle(store.repositoryFullName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if store.isLoading {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ProgressView()
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear { store.send(.fetchPullRequests) }
            .sheet(item: $store.scope(state: \.pullRequestDetails, action: \.pullRequestDetails)) { store in
                PullRequestDetailsView(store: store)
            }
        }
    }
}
