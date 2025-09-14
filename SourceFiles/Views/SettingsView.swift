import SwiftUI
import Combine

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @State private var excludedAppName = ""
    
    var body: some View {
        VStack {
            TabView {
                // General Settings
                Form {
                    Section(header: Text("General")) {
                        Toggle("Enable JClickBeats", isOn: $settings.isEnabled)
                            .onChange(of: settings.isEnabled) { old, new in
                                audioManager.restartMonitoring(with: settings)
                            }
                        
                        Toggle("Mouse Click Sounds", isOn: $settings.mouseClickEnabled)
                            .onChange(of: settings.mouseClickEnabled) { old, new in
                                audioManager.restartMonitoring(with: settings)
                            }
                        
                        Picker("Play sounds through:", selection: $settings.outputDevice) {
                            ForEach(AppSettings.OutputDevice.allCases, id: \.self) { device in
                                Text(device.rawValue).tag(device)
                            }
                        }
                        
                        HStack {
                            Text("Volume")
                            Slider(value: $settings.volume, in: 0...1)
                                .onChange(of: settings.volume) { old, newVolume in
                                    audioManager.updateVolume(newVolume)
                                }
                            Text("\(Int(settings.volume * 100))%")
                                .frame(width: 40)
                        }
                    }
                    
                    Section(header: Text("Permissions")) {
                        if accessibilityManager.hasAccess {
                            Label("Accessibility Access Granted", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Accessibility access is required for JClickBeats to work")
                                    .foregroundColor(.red)
                                
                                Button("Open System Preferences") {
                                    audioManager.requestAccessibilityAccess()
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Excluded Applications")) {
                        HStack {
                            TextField("Application name", text: $excludedAppName)
                            Button("Add") {
                                if !excludedAppName.isEmpty && !settings.excludedApps.contains(excludedAppName) {
                                    settings.excludedApps.append(excludedAppName)
                                    excludedAppName = ""
                                }
                            }
                        }
                        
                        List {
                            ForEach(settings.excludedApps, id: \.self) { app in
                                Text(app)
                            }
                            .onDelete { indices in
                                settings.excludedApps.remove(atOffsets: indices)
                            }
                        }
                        .frame(height: 100)
                    }
                }
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .padding()
                
                // Hotkeys Settings
                Form {
                    Section(header: Text("Keyboard Shortcuts")) {
                        HStack {
                            Text("Toggle JClickBeats")
                            Spacer()
                            Text("⌘+Shift+K")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Increase Volume")
                            Spacer()
                            Text("⌘+↑")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Decrease Volume")
                            Spacer()
                            Text("⌘+↓")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section(header: Text("Custom Shortcuts")) {
                        Text("Custom shortcuts coming soon...")
                            .foregroundColor(.secondary)
                    }
                }
                .tabItem {
                    Label("Shortcuts", systemImage: "command")
                }
                .padding()
                
                // Sound Profiles Settings
                Form {
                    Section(header: Text("Keyboard Sound Profile")) {
                        Picker("Profile", selection: Binding(
                            get: { audioManager.currentProfile?.name ?? "Classic Keyboard" },
                            set: { name in
                                if let profile = SoundProfile.sampleProfiles.first(where: { $0.name == name }) {
                                    audioManager.setProfile(profile)
                                }
                            }
                        )) {
                            ForEach(SoundProfile.sampleProfiles.filter { $0.category != "Mouse Clicks" }, id: \.name) { profile in
                                Text(profile.name).tag(profile.name)
                            }
                        }
                    }
                    
                    Section(header: Text("Mouse Click Sound Profile")) {
                        Picker("Profile", selection: Binding(
                            get: { audioManager.currentMouseProfile?.name ?? "Mouse Classic" },
                            set: { name in
                                if let profile = SoundProfile.sampleProfiles.first(where: { $0.name == name }) {
                                    audioManager.setMouseProfile(profile)
                                }
                            }
                        )) {
                            ForEach(SoundProfile.sampleProfiles.filter { $0.category == "Mouse Clicks" }, id: \.name) { profile in
                                Text(profile.name).tag(profile.name)
                            }
                        }
                    }
                }
                .tabItem {
                    Label("Sounds", systemImage: "speaker.wave.2")
                }
                .padding()
            }
            .frame(width: 400, height: 300)
            
            Button("Close") {
                NSApp.windows.first(where: { $0.title == "JClickBeats Settings" })?.close()
            }
            .padding(.bottom)
        }
    }
}
