import SwiftUI

struct PrefsView: View {
    @ObservedObject var prefs: Prefs
    @State var prefsWindowDelegate = PrefsWindowDelegate()
    private enum Tabs: Hashable {
        case address
        case api
        case credit
    }
    
    var body: some View {
        TabView {
            AddressControlView().environmentObject(prefs)
                .tabItem {
                    Text("Address")
                }
                .tag(Tabs.address)
            APISettingsView()
                .tabItem {
                    Text("API")
                }
                .tag(Tabs.api)
            CreditView()
                .tabItem {
                    Text("Credit")
                }
                .tag(Tabs.credit)
        }
        .padding(20)
        .frame(width: 375, height: 300)
        
    }
    
    var window: NSWindow!
    init(prefs: Prefs) {
        self.prefs = prefs
        
        window = NSWindow.createStandardWindow(withTitle: "Preferences",
                                               width: 300,
                                               height: 100)
        window.contentView = NSHostingView(rootView: self)
        window.delegate = prefsWindowDelegate
        window.center()
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

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView(prefs: Prefs())
    }
}
