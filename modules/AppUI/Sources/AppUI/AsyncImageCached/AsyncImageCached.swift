//
//  AsyncImageCached.swift
//  AppUI
//
//  Created by Tassio Marques on 18/02/25.
//

import Foundation
import SwiftUI

public struct AsyncImageCached<Content>: View where Content: View  {
    private let url: URL?
    private let cache: any ImageCachable
    private let content: (AsyncImagePhase) -> Content
    
    public init(url: URL?,
                cache: any ImageCachable = ImageCache.shared,
                content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.cache = cache
        self.content = content
    }
    
    public var body: some View {
        if let url {
            if let image = cache.getValue(forKey: url.absoluteString) {
                content(.success(image))
            } else {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        cache.setValue(image, forKey: url.absoluteString)
                    }
                    return content(phase)
                }
            }
        } else {
            content(.failure(AsyncImageCachedError.invalidURL))
        }
    }
    
    enum AsyncImageCachedError: Error {
        case invalidURL
    }
}


