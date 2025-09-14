//
//  StatusMenuView.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import Combine


// MARK: - Status Menu View
struct StatusMenuView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            
            Divider()
            
            if !accessibilityManager.hasAccess {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Permissions Needed")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("JClickBeats needs accessibility access to monitor keyboard inputs.")
                        .font(.caption)
                    
                    Button("Grant Access") {
                        audioManager.requestAccessibilityAccess()
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
            }
            
            Text("Keyboard: \(audioManager.currentProfile?.name ?? "None")")
                .font(.headline)
            
            Text("Mouse: \(audioManager.currentMouseProfile?.name ?? "None")")
                .font(.headline)
            
            HStack {
                Text("Volume")
                Slider(value: $settings.volume, in: 0...1)
                    .frame(width: 150)
                    .onChange(of: settings.volume) { old, newVolume in
                        audioManager.updateVolume(newVolume)
                    }
                Text("\(Int(settings.volume * 100))%")
                    .frame(width: 40)
            }
            
            Toggle("Mouse Click Sounds", isOn: $settings.mouseClickEnabled)
                .onChange(of: settings.mouseClickEnabled) { old, new in
                    audioManager.restartMonitoring(with: settings)
                }
            
            Button("Settings") {
                SettingsWindowManager.shared.showSettings()
            }
            
            Divider()
            
            Button("Quit JClickBeats") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
    }
}
