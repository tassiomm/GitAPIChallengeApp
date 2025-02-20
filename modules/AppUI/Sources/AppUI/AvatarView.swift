//
//  AvatarView.swift
//  AppUI
//
//  Created by Tassio Marques on 16/02/25.
//

import SwiftUI

public struct AvatarView: View {
    let imageUrl: String
    let username: String
    
    enum Layout {
        static let imageSide: CGFloat = 60.0
    }
    
    public init(imageUrl: String, username: String) {
        self.imageUrl = imageUrl
        self.username = username
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            AsyncImageCached(url: URL(string: imageUrl)) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                    case .failure:
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                .frame(width: Layout.imageSide, height: Layout.imageSide)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            Text(username)
                .font(.headline)
                .foregroundColor(.blue.opacity(0.7))
        }.lineLimit(1)
    }
}

#Preview {
    AvatarView(imageUrl: "https://static.thenounproject.com/png/2616533-200.png",
               username: "tassiomm")
}


