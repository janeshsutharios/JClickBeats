//
//  KeyBellApp.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import Combine

// MARK: - Main App
@main
struct KeyBellApp: App {
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var settings = AppSettings()
    @StateObject private var accessibilityManager = AccessibilityManager()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(settings)
                .environmentObject(accessibilityManager)
                .onAppear {
                    NSApp.setActivationPolicy(.regular)
                    // Update AudioManager with shared settings
                    audioManager.updateSettings(settings)
                    // Hide the window initially if we don't have accessibility access
                    if !accessibilityManager.hasAccess {
                        NSApp.windows.first?.orderOut(nil)
                    }
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(after: .appSettings) {
                Button("Settings...") {
                    SettingsWindowManager.shared.showSettings()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
