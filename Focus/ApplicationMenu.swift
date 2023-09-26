//
//  ApplicationMenu.swift
//  Focus
//
//  Created by Musab Abdullah on 9/20/23.
//

import Foundation
import SwiftUI


class ApplicationMenu: NSObject {
    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let focusView = FocusView()
        
        let topView = NSHostingController(rootView: focusView)
        topView.view.frame.size = CGSize(width: 300, height: 250)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        let aboutMenuItem = NSMenuItem(title: "About Focus Timer",
                                       action: #selector(about),
                                       keyEquivalent: "")
        aboutMenuItem.target = self
        menu.addItem(aboutMenuItem)
        
        let webLinkMenuItem = NSMenuItem(title: "Musab Abdullah",
                                       action: #selector(openLink),
                                       keyEquivalent: "")
        webLinkMenuItem.target = self
        webLinkMenuItem.representedObject = "https://musababdullah.webflow.io"
        menu.addItem(webLinkMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit",
                                       action: #selector(quit),
                                       keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        return menu
    }
    
    @objc func about(sender: NSMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSApplication.shared.orderFrontStandardAboutPanel()
    }
    
    @objc func openLink(sender: NSMenuItem) {
        let link = sender.representedObject as! String
        guard let url = URL(string: link) else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
