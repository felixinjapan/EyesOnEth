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
    init<T: View>(_ uiview:T) {
        // Create the window and set the content view.
        let window = NSWindow.createStandardWindow(withTitle: "", width: 480, height: 300)
        window.titleVisibility = .hidden
        window.tabbingMode = .disallowed
        window.contentView = NSHostingView(rootView: uiview)
        window.makeKeyAndOrderFront(nil)
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
}

extension NSWindow {
    
    static func createStandardWindow(withTitle title: String,
                                     width: CGFloat = 800, height: CGFloat = 600) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.title = title
        return window
    }
    
}
