//
//  AudioManager.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import AppKit
import AVFoundation
import Combine


// MARK: - Audio Manager
class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var eventMonitor: Any?
    private var mouseMonitor: Any?
    private var settings: AppSettings
    private let accessibilityManager = AccessibilityManager()
    
    @Published var currentProfile: SoundProfile?
    @Published var currentMouseProfile: SoundProfile?
    @Published var isActive: Bool = true
    
    private override init() {
        self.settings = AppSettings()
        super.init()
        setupAudioPlayers()
        
        // Start checking permissions with a small delay to allow UI to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkPermissionsAndStartMonitoring()
        }
    }
    
    func updateSettings(_ newSettings: AppSettings) {
        self.settings = newSettings
        restartMonitoring()
    }
    
    private func setupAudioPlayers() {
        // Load sound files from Keyboard/ and Mouse/ subdirectories
        for profile in SoundProfile.sampleProfiles {
            for soundFile in profile.soundFiles {
                // Create a system sound for demonstration
                // In a real app, you would load custom audio files
                if let path = Bundle.main.path(forResource: soundFile, ofType: "wav") {
                    let url = URL(fileURLWithPath: path)
                    do {
                        let player = try AVAudioPlayer(contentsOf: url)
                        player.prepareToPlay()
                        audioPlayers[soundFile] = player
                        player.volume = Float(settings.volume)
                    } catch {
                        print("Error loading sound file: \(error)")
                        // Fallback to system sound if custom file not found
                    }
                } else {
                    // Use system sound as fallback for demonstration
                    // In a real app, you would include your actual sound files
                    print("Sound file \(soundFile) not found, using fallback")
                }
            }
        }
        
        // Set default profiles
        currentProfile = SoundProfile.sampleProfiles.first
        currentMouseProfile = SoundProfile.sampleProfiles.first(where: { $0.category == "Mouse Clicks" })
    }
    
    private func checkPermissionsAndStartMonitoring() {
        accessibilityManager.checkAccessibilityPermissions()
        
        if accessibilityManager.hasAccess {
            startMonitoring()
        } else {
            // Try again after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.checkPermissionsAndStartMonitoring()
            }
        }
    }
    
    private func startMonitoring() {
        // Stop existing monitors if any
        stopMonitoring()
        
        // Check if we have accessibility access
        guard accessibilityManager.hasAccess else { return }
        
        // Monitor keyboard events
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self = self, self.isActive, self.settings.isEnabled else { return }
            
            // Check if current app is not in excluded list
            if let currentApp = NSWorkspace.shared.frontmostApplication?.localizedName,
               self.settings.excludedApps.contains(currentApp) {
                return
            }
            
            self.playRandomKeySound()
        }
        
        // Monitor mouse click events
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, self.isActive, self.settings.isEnabled, self.settings.mouseClickEnabled else { return }
            
            // Check if current app is not in excluded list
            if let currentApp = NSWorkspace.shared.frontmostApplication?.localizedName,
               self.settings.excludedApps.contains(currentApp) {
                return
            }
            
            self.playRandomMouseSound()
        }
        
        settings.hasAccessibilityAccess = true
    }
    
    private func playRandomKeySound() {
        guard let profile = currentProfile,
              let randomSound = profile.soundFiles.randomElement() else { return }
        
        // Play the sound if we have a player for it
        if let player = audioPlayers[randomSound] {
            player.currentTime = 0
            player.play()
        } else {
            // Fallback to system sound
         //   NSSound(named: .init(rawValue: "Funk"))?.play()
        }
    }
    
    private func playRandomMouseSound() {
        guard let profile = currentMouseProfile,
              let randomSound = profile.soundFiles.randomElement() else { return }
        
        // Play the sound if we have a player for it
        if let player = audioPlayers[randomSound] {
            player.currentTime = 0
            player.play()
        } else {
            // Fallback to system sound
         //   NSSound(named: .init(rawValue: "Funk"))?.play()
        }
    }
    
    func stopMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = mouseMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    func setProfile(_ profile: SoundProfile) {
        currentProfile = profile
        settings.selectedProfile = profile.name
    }
    
    func setMouseProfile(_ profile: SoundProfile) {
        currentMouseProfile = profile
        settings.selectedMouseProfile = profile.name
    }
    
    func updateVolume(_ volume: Double) {
        // Update volume for all audio players
        for (_, player) in audioPlayers {
            player.volume = Float(volume)
        }
    }
    
    func restartMonitoring() {
        // Restart monitoring when settings change
        if accessibilityManager.hasAccess {
            startMonitoring()
        }
    }
    
    func restartMonitoring(with settings: AppSettings) {
        // Restart monitoring with specific settings
        self.settings = settings
        if accessibilityManager.hasAccess {
            startMonitoring()
        }
    }
    
    func requestAccessibilityAccess() {
        accessibilityManager.requestAccessibilityPermissions()
        
        // Check again after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.accessibilityManager.checkAccessibilityPermissions()
            if self.accessibilityManager.hasAccess {
                self.startMonitoring()
            }
        }
    }
    func checkAndUpdateAccessibilityStatus() {
        accessibilityManager.checkAccessibilityPermissions()
        
        if accessibilityManager.hasAccess && !settings.hasAccessibilityAccess {
            // Permission was just granted
            settings.hasAccessibilityAccess = true
            startMonitoring()
        } else if !accessibilityManager.hasAccess && settings.hasAccessibilityAccess {
            // Permission was revoked
            settings.hasAccessibilityAccess = false
            stopMonitoring()
        }
    }
}
