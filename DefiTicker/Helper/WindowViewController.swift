//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa
import AppKit
import SwiftUI

class WindowViewController: NSWindowController {
    let prefs = Prefs()
    
    override func loadWindow() {
    }
    
    init<T: View>(_ uiview:T) {
        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.titleVisibility = .hidden
        window.tabbingMode = .disallowed
        window.contentView = NSHostingView(rootView: uiview.environmentObject(prefs))
        window.makeKeyAndOrderFront(nil)
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
}
