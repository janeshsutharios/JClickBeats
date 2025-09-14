//
//  ProfileCard.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import Combine

// MARK: - Profile Card View
struct ProfileCard: View {
    let profile: SoundProfile
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
                
                VStack(spacing: 12) {
                    Image(systemName: profile.imageName)
                        .font(.system(size: 32))
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    Text(profile.name)
                        .font(.headline)
                        .foregroundColor(isSelected ? .blue : .primary)
                }
                .padding()
            }
            .frame(height: 120)
        }
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard(
            profile: SoundProfile.sampleProfiles[0],
            isSelected: true
        )
        .frame(width: 150, height: 120)
    }
}
