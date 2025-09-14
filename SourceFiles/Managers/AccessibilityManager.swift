//
//  AccessibilityManager.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import AppKit
import Combine
import SwiftUI
import AppKit
import Combine

class AccessibilityManager: ObservableObject {
    @Published var hasAccess: Bool = false
    private var continuousCheckTask: Task<Void, Never>?
    
    init() {
        checkAccessibilityPermissions()
        startContinuousChecking()
    }
    
    deinit {
        continuousCheckTask?.cancel()
    }
    
    func checkAccessibilityPermissions() {
        // Access the global variable in a non-isolated computed property
        var isTrusted: Bool {
            let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
            let options = [promptKey: false] as CFDictionary
            return AXIsProcessTrustedWithOptions(options)
        }
        // Use MainActor to ensure UI updates on main thread
        Task { @MainActor in
            self.hasAccess = isTrusted
        }
    }
    
    func startContinuousChecking() {
        // Cancel any existing task
        continuousCheckTask?.cancel()
        
        continuousCheckTask = Task {
            while !Task.isCancelled && !hasAccess {
                // Check permissions every second
                checkAccessibilityPermissions()
                
                // Wait for 1 second, but check for cancellation frequently
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    // Task was cancelled
                    break
                }
            }
        }
    }
    
    func requestAccessibilityPermissions() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
        
        // Restart continuous checking
        startContinuousChecking()
    }
}
