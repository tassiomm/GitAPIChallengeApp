//
//  UserAvatarView.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import SwiftUI
import AppUI

struct UserAvatarView: View {
    let model: UserAvatarViewModel
    
    enum Layout {
        static let imageSide = 40.0
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.15))

            HStack(alignment: .center, spacing: 15) {
                AsyncImageCached(url: URL(string: model.avatarUrl)) { phase in
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

                VStack(alignment: .leading) {
                    Text("text_author")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    Text(model.author)
                        .font(.body)
                        .foregroundStyle(Color.blue)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct UserAvatarViewModel {
    let avatarUrl: String
    let author: String
}

#Preview {
    UserAvatarView(model: .init(avatarUrl: "", author: ""))
}
