//
//  SoundProfile.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import Foundation

struct SoundProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let imageName: String
    let soundFiles: [String]
}

