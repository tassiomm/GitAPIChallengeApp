import XCTest
@testable import RepositoriesFeature
import ComposableArchitecture

final class PullRequestDetailsFeatureTests: XCTestCase {
    
    @MainActor
    func test_actionUpdateIsLoading_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url)
        
        await store.send(.updateIsLoading(true)) {
            $0.isLoading = true
        }
        
        await store.send(.updateIsLoading(false)) {
            $0.isLoading = false
        }
    }
    
    @MainActor
    func test_actionWebViewPhase_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url)
        
        await store.send(.webViewPhase(.didStartProvisionalNavigation)) {
            $0.isLoading = true
        }
        
        await store.send(.webViewPhase(.didFinish)) {
            $0.isLoading = false
        }
        
        await store.send(.webViewPhase(.didStartProvisionalNavigation)) {
            $0.isLoading = true
        }
        
        let expectedError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "error description"])
        await store.send(.webViewPhase(.didFail(expectedError))) {
            $0.isLoading = false
            $0.alert = AlertState { TextState(expectedError.localizedDescription) }
        }
    }
    
    private func makeSUT(url: URL) -> TestStore<PullRequestDetailsFeature.State, PullRequestDetailsFeature.Action> {
        TestStore(initialState: PullRequestDetailsFeature.State(url: url)) { PullRequestDetailsFeature() }
    }
}
