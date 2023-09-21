//
//  FocusApp.swift
//  Focus
//
//  Created by Musab Abdullah on 9/14/23.
//

import SwiftUI

@main
struct FocusApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
                EmptyView()
            }
//        WindowGroup {
//            FocusView()
//        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }
}

