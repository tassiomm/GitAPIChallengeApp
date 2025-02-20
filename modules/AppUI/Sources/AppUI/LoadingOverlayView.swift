//
//  LoadingOverlayView.swift
//  AppUI
//
//  Created by Tassio Marques on 17/02/25.
//

import SwiftUI

public struct LoadingOverlayView: View {
    private var isLoading: Binding<Bool>
    private let message: String
    
    public init(isLoading: Binding<Bool>, message: String) {
        self.isLoading = isLoading
        self.message = message
    }
    
    public var body: some View {
        if isLoading.wrappedValue {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView(message)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .padding()
            }
        } else {
            EmptyView()
        }
    }
}
