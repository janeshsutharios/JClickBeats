// MARK: - Sample Data
import Foundation
extension SoundProfile {
    static let sampleProfiles: [SoundProfile] = [
        SoundProfile(
            name: "Classic Typewriter",
            category: "Mechanical Keyboards",
            imageName: "keyboard",
            soundFiles: ["mech_key1", "mech_key2", "mech_key3", "mech_key4", "mech_key5", "mech_key6"]
        ),
        SoundProfile(
            name: "Mouse Classic",
            category: "Mouse Clicks",
            imageName: "computermouse",
            soundFiles: ["mouse"]
        )
    ]
    
    static var categories: [String] {
        return Array(Set(sampleProfiles.map { $0.category })).sorted()
    }
    
    static func profiles(for category: String) -> [SoundProfile] {
        return sampleProfiles.filter { $0.category == category }
    }
}
