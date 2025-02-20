//
//  IconTextView.swift
//  AppUI
//
//  Created by Tassio Marques on 17/02/25.
//

import SwiftUI

public struct IconTextView: View {
    let icon: Image
    let text: String
    let textColor: Color
    
    public init(icon: Image, 
                text: String,
                textColor: Color = .darkYellow) {
        self.icon = icon
        self.text = text
        self.textColor = textColor
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            icon
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(text)
                .lineLimit(1)
                .offset(x: -5)
        }
        .foregroundColor(textColor)
    }
}
