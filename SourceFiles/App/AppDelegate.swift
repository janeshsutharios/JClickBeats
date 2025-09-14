//
//  AppDelegate.swift
//  JClickBeats
//
//  Created by Janesh Suthar on 13/09/25.
//


import SwiftUI
import AppKit
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        createStatusItem()
        // Hide the dock icon
        NSApp.setActivationPolicy(.accessory)
    }
    
    func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            if let img = NSImage(named: "click") {
                button.image = img
            } else {
                button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "JClickBeats")
            }
            button.action = #selector(togglePopover)
        }
        
        let contentView = StatusMenuView()
            .environmentObject(AudioManager.shared)
            .environmentObject(AppSettings())
            .environmentObject(AccessibilityManager())
        
        popover.contentViewController = NSHostingController(
            rootView: contentView.frame(width: 300, height: 400)
        )
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
