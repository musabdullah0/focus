//
//  ApplicationMenu.swift
//  Focus
//
//  Created by Musab Abdullah on 9/20/23.
//

import Foundation
import SwiftUI


class ApplicationMenu: NSObject {    
    func createMenu(nsMenu: CustomNSMenu, focusView: FocusView) -> CustomNSMenu {
        let topView = NSHostingController(rootView: focusView)
        topView.view.frame.size = CGSize(width: 350, height: 220)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        nsMenu.addItem(customMenuItem)
        nsMenu.addItem(NSMenuItem.separator())
        
        let aboutMenuItem = NSMenuItem(title: "About Focus Timer",
                                       action: #selector(about),
                                       keyEquivalent: "")
        aboutMenuItem.target = self
        nsMenu.addItem(aboutMenuItem)
        
        let webLinkMenuItem = NSMenuItem(title: "Musab Abdullah",
                                       action: #selector(openLink),
                                       keyEquivalent: "")
        webLinkMenuItem.target = self
        webLinkMenuItem.representedObject = "https://musababdullah.webflow.io"
        nsMenu.addItem(webLinkMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit",
                                       action: #selector(quit),
                                       keyEquivalent: "q")
        quitMenuItem.target = self
        nsMenu.addItem(quitMenuItem)
        
        return nsMenu
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
