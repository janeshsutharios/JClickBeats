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
    private var timer: Timer?
    
    init() {
        checkAccessibilityPermissions()
        startContinuousChecking()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func checkAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary?)
        DispatchQueue.main.async {
            self.hasAccess = trusted
        }
    }
    
    func startContinuousChecking() {
        // Check every second until access is granted
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.hasAccess {
                self.checkAccessibilityPermissions()
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    func requestAccessibilityPermissions() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
        
        // Restart continuous checking
        timer?.invalidate()
        startContinuousChecking()
    }
}
