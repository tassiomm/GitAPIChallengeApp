//
//  RepositoryRowView.swift
//  AppUI
//
//  Created by Tassio Marques on 16/02/25.
//

import SwiftUI
import AppUI

public struct RepositoryRowView: View {
    let model: Model
    
    public init(model: Model) {
        self.model = model
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(model.name)
                    .font(.title3)
                    .lineLimit(1)
                    .foregroundStyle(Color.blue)
                    .bold()
                
                Text(model.description)
                    .font(.body)
                    .lineLimit(2)
                
                HStack(spacing: 10) {
                    IconTextView(icon: Image("git_fork"),
                                 text: "\(model.forkCount)")
                    IconTextView(icon: Image(systemName: "star.fill"),
                                 text: "\(model.starsCount)")
                    Spacer()
                }
                .fontWeight(.bold)
                .foregroundColor(.yellow)
            }
            
            Spacer(minLength: 15)
            
            if let owner = model.owner {
                AvatarView(imageUrl: owner.avatarUrl, username: owner.username)
                    .frame(width: 120)
            }
        }
    }
}

