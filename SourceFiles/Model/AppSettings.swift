//
//  AppSettings.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import Foundation
import Combine

class AppSettings: ObservableObject {
    @Published var volume: Double = 0.7
    @Published var isEnabled: Bool = true
    @Published var selectedProfile: String = "Classic Typewriter"
    @Published var outputDevice: OutputDevice = .any
    @Published var excludedApps: [String] = []
    @Published var hasAccessibilityAccess: Bool = false
    @Published var mouseClickEnabled: Bool = true
    @Published var selectedMouseProfile: String = "Mouse Classic"
    
    enum OutputDevice: String, CaseIterable {
        case any = "Any"
        case speakers = "Speakers Only"
        case headphones = "Headphones Only"
    }
}
