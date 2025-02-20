//
//  IconTextView.swift
//  AppUI
//
//  Created by Tassio Marques on 17/02/25.
//

import SwiftUI

struct IconTextView: View {
    let icon: Image
    let text: String
    
    var body: some View {
        HStack {
            icon
            
            Text(text)
                .lineLimit(1)
                .offset(x: -5)
        }
        .foregroundColor(.darkYellow)
    }
}
