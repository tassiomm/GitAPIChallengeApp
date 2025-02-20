//
//  SearchResultListView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import ComposableArchitecture
import SwiftUI
import AppUI
import RepositoriesProviderInterface

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
                }.background(Color.gray.opacity(0.15))
            }
        }
    }
    
    private func RepositoriesList() -> some View {
        ForEach(Array(zip(store.repositories.indices, store.repositories)), id: \.0) { (index, element) in
            RepositoryRow(element, at: index)
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Color.white)
                .onTapGesture {
                    store.send(.showPullRequests(repositoryFullName: element.fullName))
                }
        }
    }
    
    private func RepositoryRow(_ element: Repository, at index: Int) -> some View {
        RepositoryRowView(model: .
                          init(name: element.name,
                               description: element.description ?? "",
                               forkCount: element.forksCount,
                               starsCount: element.startCount,
                               owner: .init(avatarUrl: element.owner.avatarURL, username: element.owner.login)))
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
