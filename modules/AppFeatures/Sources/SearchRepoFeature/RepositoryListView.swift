//
//  SearchResultListView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import ComposableArchitecture
import SwiftUI
import AppUI

struct RepositoryListView: View {
    @Perception.Bindable var store: StoreOf<RepositoryListFeature>
    
    enum Layout {
        static let rowVerticalInsets = 12.0
    }
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        RepositoriesList()
                        
                        if store.isLoading && store.errorMessage == nil {
                            ProgressView()
                                .padding()
                        }
                        
                        if store.errorMessage != nil {
                            ErrorView()
                                .padding(.horizontal, 15)
                        }
                    }
                    .onAppear { store.send(.fetchNewPage(reload: true)) }
                    .navigationTitle(Localized("repositories_title", "Swift"))
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(item: $store.scope(state: \.pullRequests, action: \.pullRequests)) { store in
                        PullRequestsListView(store: store)
                    }
                }
            }
        }
    }
    
    private func RepositoriesList() -> some View {
        ForEach(Array(zip(store.repositories.indices, store.repositories)), id: \.0) { (index, element) in
            RepositoryRow(element, at: index)
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .onTapGesture {
                    store.send(.showPullRequests(repositoryFullName: element.full_name))
                }
            Divider()
                .padding(.leading, 15)
        }
    }
    
    private func RepositoryRow(_ element: RepositoryEntity, at index: Int) -> some View {
        RepositoryRowView(model: .
                          init(name: element.name,
                               description: element.description ?? "",
                               forkCount: element.forks_count,
                               starsCount: element.stargazers_count,
                               owner: .init(avatarUrl: element.owner.avatar_url, username: element.owner.login)))
        .listRowInsets(.init(top: Layout.rowVerticalInsets,
                             leading:  Layout.rowVerticalInsets,
                             bottom:  Layout.rowVerticalInsets,
                             trailing:  Layout.rowVerticalInsets))
        .onAppear {
            store.send(.fetchPageIfNeeded(index: index))
        }
    }
    
    private func ErrorView() -> some View {
        var message: String?
        #if DEBUG
        message = store.errorMessage
        #endif
        return MessageActionView(title: Localized("error_message_generic_retry"),
                                 message: message, buttonText: Localized("button_retry")) {
            store.send(.fetchNewPage(reload: false))
        }
    }
}

public func Localized(_ key: String, _ arg1: any CVarArg...) -> String {
    return String(format: NSLocalizedString(key, comment: ""), arg1)
}

