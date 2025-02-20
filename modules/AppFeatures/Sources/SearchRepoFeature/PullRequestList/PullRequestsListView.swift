//
//  PullRequestsListView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//


import ComposableArchitecture
import SwiftUI
import AppUI
import RepositoriesProviderInterface
import RepositoriesAPIInterface

struct PullRequestsListView: View {
    @Perception.Bindable var store: StoreOf<PullRequestsListFeature>
    
    enum Layout {
        static let rowVerticalInsets = 8.0
        static let rowHorizontalInsets = 15.0
        static let imageSide = 40.0
    }
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.gray.opacity(0.15)
                    .ignoresSafeArea()
                if store.pullRequests.isEmpty && store.isLoading == false {
                    Text(String(localized: "no_open_pull_requests_message"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .ignoresSafeArea()
                } else {
                    PullRequestListing()
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
            .onAppear { store.send(.fetchPullRequests) }
            .sheet(item: $store.scope(state: \.pullRequestDetails, action: \.pullRequestDetails)) { store in
                PullRequestDetailsView(store: store)
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
    private func PullRequestListing() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(store.pullRequests) { pullRequest in
                    buildPullRequestRow(for: pullRequest)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                }
            }
        }
    }
    
    private func buildPullRequestRow(for pullRequest: PullRequestEntity) -> some View {
        VStack(alignment: .leading) {
            Text(pullRequest.title)
                .font(.title3)
                .foregroundStyle(Color.blue)
                .bold()
            Text(pullRequest.body ?? "")
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
}
