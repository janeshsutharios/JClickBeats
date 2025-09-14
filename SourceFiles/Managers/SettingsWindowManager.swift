//
//  SettingsWindowManager.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import AppKit
import Combine


// MARK: - Settings Window Manager
class SettingsWindowManager: ObservableObject {
    static let shared = SettingsWindowManager()
    
    private var settingsWindow: NSWindow?
    
    func showSettings() {
        if settingsWindow == nil {
            createSettingsWindow()
        }
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func createSettingsWindow() {
        let settingsView = SettingsView()
            .environmentObject(AudioManager.shared)
            .environmentObject(AppSettings())
            .environmentObject(AccessibilityManager())
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.center()
        window.title = "JClickBeats Settings"
        window.contentView = NSHostingView(rootView: settingsView)
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        
        settingsWindow = window
    }
}
