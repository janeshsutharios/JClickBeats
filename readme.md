# JClickBeats - README

![JClickBeats](https://img.shields.io/badge/macOS-13.0+-blue?style=for-the-badge&logo=apple)
![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=for-the-badge&logo=swift)
A beautiful macOS application that provides satisfying mechanical keyboard sounds and mouse click feedback as you type and click. Transform your typing experience with customizable sound profile.


## ✨ Features

- **Mechanical Keyboard Sounds**: Enjoy realistic mechanical keyboard sounds as you type
- **Mouse Click Feedback**: Get satisfying auditory feedback for mouse clicks
- **Per-App Customization**: Enable/disable sounds for specific applications
- **Auto-Enable Features**: Automatically activate based on output device
- **Global Hotkeys**: Quick controls for volume and activation
- **Menu Bar Access**: Quick access from your macOS menu bar
- **Privacy Focused**: No data collection, all processing happens locally

## 🚀 Installation

### Prerequisites
- macOS 13.0 or later
- Xcode 26.0 or later (for building from source)

### Download
1. Download the latest release from the [Releases page](https://github.com/janeshsutharios/JClickBeats/releases)
2. Drag JClickBeats to your Applications folder
3. Open JClickBeats (you may need to right-click and select "Open" due to macOS security settings)

### Build from Source
```bash
git clone https://github.com/janeshsutharios/JClickBeats.git
cd JClickBeats
open JClickBeats.xcodeproj
```

In Xcode:
1. Select your development team in Signing & Capabilities
2. Build and run (⌘R)

## 🔧 Setup

### Accessibility Permissions
JClickBeats requires accessibility access to monitor keyboard and mouse events:

1. Open System Preferences → Security & Privacy → Privacy → Accessibility
2. Click the lock icon to make changes (bottom left)
3. Check the box next to JClickBeats
4. If JClickBeats isn't in the list, click the "+" button and navigate to your Applications folder to add it

### Audio Permissions
The app may request microphone access - this is normal for audio applications and can be granted for full functionality.

## 🎮 Usage

### Basic Operation
1. Launch JClickBeats from your Applications folder
2. The app will appear in your menu bar (keyboard icon)
3. Click the menu bar icon to access quick settings
4. Select your preferred sound profile
5. Adjust volume using the slider
6. Start typing to hear the mechanical keyboard sounds!


### Hotkeys
Default keyboard shortcuts:
- `⌘ + Shift + K`: Toggle JClickBeats on/off
- `⌘ + ↑`: Increase volume
- `⌘ + ↓`: Decrease volume

Customize these in Settings → Shortcuts.

## 🛠️ Configuration


### Auto-Enable Features
Configure JClickBeats to automatically enable when:
- Headphones are connected
- External speakers are detected
- Specific applications are launched

## 🤝 Contributing

We love contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Areas for Contribution
- New sound profiles
- UI/UX improvements
- Performance optimizations
- Documentation
- Translation/localization
