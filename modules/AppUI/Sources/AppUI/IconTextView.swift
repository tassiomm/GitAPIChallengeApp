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
    
    public init(icon: Image, text: String) {
        self.icon = icon
        self.text = text
    }
    
    public var body: some View {
        HStack {
            icon
            
            Text(text)
                .lineLimit(1)
                .offset(x: -5)
        }
        .foregroundColor(.darkYellow)
    }
}
