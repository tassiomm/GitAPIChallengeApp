//
//  WebView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import WebKit
import SwiftUI

public struct WebView: UIViewRepresentable {
    private let url: URL
    private let phase: (WebViewPhase) -> Void
    
    public init(url: URL, phase: @escaping (WebViewPhase) -> Void) {
        self.url = url
        self.phase = phase
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        return webview
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.navigationDelegate = context.coordinator
        uiView.load(request)
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self, phase: phase)
    }
    
    public enum WebViewPhase {
        case didFinish
        case didFail(Error)
        case didStartProvisionalNavigation
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        var phase: (WebView.WebViewPhase) -> Void
        
        init(_ parent: WebView, phase: @escaping (WebView.WebViewPhase) -> Void) {
            self.parent = parent
            self.phase = phase
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            phase(.didStartProvisionalNavigation)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            phase(.didFinish)
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            phase(.didFail(error))
        }
    }
}
