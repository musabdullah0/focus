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
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: 35)
    let menu = ApplicationMenu()
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.menu = menu.createMenu()
        statusBarItem.button?.title = "25:00"
    }
    
    @objc func openMenu() {
        NSApp.activate(ignoringOtherApps: true)

        // got from p0deje/Maccy
        // simulates mouse click on NSStatusBarItem to open menu after timer is done
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: false) { _ in
            self.statusBarItem.button?.performClick(self)
        }
        
    }
}

