//
//  SearchResultListView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import ComposableArchitecture
import SwiftUI
import AppUI
import RepositoriesRepositoryInterface

struct RepositoryListView: View {
    @Perception.Bindable var store: StoreOf<RepositoryListFeature>
    
    enum Layout {
        static let rowVerticalInsets = 12.0
        static let errorViewHorizontalPadding: CGFloat = 30
    }
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        RepositoriesList()
                        
                        if store.isLoading && store.errorMessage == nil {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                                .transition(.opacity)
                        } else if store.errorMessage == nil {
                            ErrorView()
                                .padding(.horizontal, Layout.errorViewHorizontalPadding)
                                .padding(.vertical)
                        }
                    }
                    .onAppear {
                        if store.repositories.isEmpty {
                            store.send(.fetchNewPage(reload: true))
                        }
                    }
                }
                .background(Color.backgroundGray)
                .animation(.easeInOut(duration: 0.3), value: store.isLoading)
                .modifier(RefreshableModifier(active: true, action: {
                    store.send(.fetchNewPage(reload: true))
                }))
                .navigationTitle(Localized("repositories_title", store.language))
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $store.scope(state: \.pullRequests, action: \.pullRequests)) { store in
                    PullRequestsListView(store: store)
                }
                .toolbar {
                    if store.isLoading && !store.repositories.isEmpty {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ProgressView()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
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
            //store.send(.fetchPageIfNeeded(index: index))
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

struct RefreshableModifier: ViewModifier {
    let active: Bool
    let action: () -> Void
    
    func body(content: Content) -> some View {
        if active {
            content.refreshable {
                action()
            }
        } else {
            content
        }
    }
}
