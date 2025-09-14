//
//  PrimaryButtonStyle.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI

// MARK: - Custom Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
