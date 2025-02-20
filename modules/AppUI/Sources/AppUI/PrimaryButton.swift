//
//  AppButton.swift
//  AppUI
//
//  Created by Tassio Marques on 19/02/25.
//

import SwiftUI

public struct PrimaryButton: View {
    let text: String
    let action: () -> Void
    
    public init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue)
                .overlay {
                    Text(text)
                        .foregroundStyle(Color.white)
                        .padding(2)
                }
                .frame(height: 40)
        }
    }
}
