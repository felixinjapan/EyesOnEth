//
//  PrefsView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 10/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct PrefsView: View {
    @ObservedObject var prefs: Prefs
    @State var prefsWindowDelegate = PrefsWindowDelegate()
    
    var body: some View {
        VStack {
//            Toggle(isOn: $prefs.showCopyright) {
//                Text("Show Copyright Notice")
//            }
            SettingsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
    
    var window: NSWindow!
    init(prefs: Prefs) {
        self.prefs = prefs
        
        window = NSWindow.createStandardWindow(withTitle: "Preferences",
                                               width: 300,
                                               height: 100)
        window.contentView = NSHostingView(rootView: self)
        window.delegate = prefsWindowDelegate
        window.tabbingMode = .disallowed
        prefsWindowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
    
    class PrefsWindowDelegate: NSObject, NSWindowDelegate {
        var windowIsOpen = false
        
        func windowWillClose(_ notification: Notification) {
            windowIsOpen = false
        }
    }
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general
    }
    var body: some View {
        TabView {
            AddressControlView()
                .tabItem {
                    Text("Address")
                }
                .tag(Tabs.general)
            GeneralSettingsView()
                .tabItem {
                    Text("API")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct AddressControlView: View {
    @State private var showPreview = true
    @State private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct GeneralSettingsView: View {
    @State private var showPreview = true
    @State private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView(prefs: Prefs())
    }
}
