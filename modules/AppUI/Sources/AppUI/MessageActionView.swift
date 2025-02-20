//
//  MessageActionView.swift
//  AppUI
//
//  Created by Tassio Marques on 19/02/25.
//

import SwiftUI

public struct MessageActionView: View {
    let title: String
    let message: String?
    let buttonText: String
    let action: () -> Void
    
    public init(title: String, message: String?, buttonText: String, action: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(title)
                .font(.headline)
                .lineLimit(nil)
            
            if let message {
                Text(message)
                    .font(.caption)
                    .lineLimit(nil)
            }
            
            PrimaryButton(text: buttonText, action: action)
        }
        .padding(.vertical, 12)
    }
}
