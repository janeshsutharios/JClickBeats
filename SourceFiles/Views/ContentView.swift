//
//  ContentView.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import AppKit
import AVFoundation
import Combine

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @State private var selectedCategory = "Mechanical Keyboards"
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "keyboard")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("JClickBeats")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                Toggle("", isOn: $settings.isEnabled)
                    .toggleStyle(SwitchToggleStyle())
                    .labelsHidden()
                    .onChange(of: settings.isEnabled) { old, new in
                        audioManager.restartMonitoring(with: settings)
                    }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Check for accessibility access with proper state management
            if !accessibilityManager.hasAccess {
                AccessibilityPermissionView()
                    .environmentObject(accessibilityManager)
                    .environmentObject(audioManager)
            } else {
                // Main app content
                MainAppContentView(selectedCategory: $selectedCategory)
                    .environmentObject(audioManager)
                    .environmentObject(settings)
            }
        }
        .frame(width: 500, height: 500)
        .onAppear {
            // Force a check when the view appears
            accessibilityManager.checkAccessibilityPermissions()
        }
    }
}

struct AccessibilityPermissionView: View {
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("Accessibility Permissions Required")
                .font(.headline)
            
            Text("JClickBeats needs accessibility access to monitor your keyboard inputs and play sounds as you type.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Button("Open System Preferences") {
                accessibilityManager.requestAccessibilityPermissions()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("1. Open System Preferences → Security & Privacy → Privacy → Accessibility")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("2. Click the lock icon and enter your password")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("3. Check the box next to JClickBeats in the application list")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("4. Return to this app and wait for automatic detection")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button("I've granted access - Check Again") {
                accessibilityManager.checkAccessibilityPermissions()
            }
            .buttonStyle(.borderless)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainAppContentView: View {
    @Binding var selectedCategory: String
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack {
            // Category Picker
            Picker("Category", selection: $selectedCategory) {
                ForEach(SoundProfile.categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Sound Profiles Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(SoundProfile.profiles(for: selectedCategory)) { profile in
                        ProfileCard(
                            profile: profile,
                            isSelected: selectedCategory == "Mouse Clicks" ?
                                audioManager.currentMouseProfile?.name == profile.name :
                                audioManager.currentProfile?.name == profile.name
                        )
                        .onTapGesture {
                            if selectedCategory == "Mouse Clicks" {
                                audioManager.setMouseProfile(profile)
                            } else {
                                audioManager.setProfile(profile)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            // Footer Controls
            VStack(spacing: 12) {
                HStack {
                    Text("Volume")
                    Slider(value: $settings.volume, in: 0...1)
                        .frame(width: 150)
                        .onChange(of: settings.volume) { old, newVolume in
                            audioManager.updateVolume(newVolume)
                        }
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.secondary)
                }
                
                Toggle("Mouse Click Sounds", isOn: $settings.mouseClickEnabled)
                    .onChange(of: settings.mouseClickEnabled) { old, new in
                        audioManager.restartMonitoring(with: settings)
                    }
            }
            .padding()
        }
    }
}
