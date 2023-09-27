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

class CustomNSMenu: NSMenu, NSMenuDelegate {
    public var isVisible: Bool!
    
    func menuWillOpen(_ menu: NSMenu) {
        isVisible = true
      }
    
    func menuDidClose(_ menu: NSMenu) {
        isVisible = false
      }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: 35)
    let menu = ApplicationMenu()
    let nsMenu = CustomNSMenu()
    let focusView = FocusView()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.menu = menu.createMenu(nsMenu: nsMenu, focusView: focusView)
        statusBarItem.menu?.delegate = nsMenu
        statusBarItem.button?.title = "25:00"
    }
    
    @objc func openMenu() {
        if !nsMenu.isVisible {
            NSApp.activate(ignoringOtherApps: true)
            
            // got from p0deje/Maccy
            // simulates mouse click on NSStatusBarItem to open menu after timer is done
            Timer.scheduledTimer(withTimeInterval: 0.04, repeats: false) { _ in
                self.statusBarItem.button?.performClick(self)
            }
        }
        
    }
}

