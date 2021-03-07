import SwiftUI

struct PrefsView: View {
    @ObservedObject var prefs: Prefs
    @State var prefsWindowDelegate = PrefsWindowDelegate()
    private enum Tabs: Hashable {
        case general
    }
    var body: some View {
        TabView {
            AddressControlView().environmentObject(prefs)
                .tabItem {
                    Text("Address")
                }
                .tag(Tabs.general)
            APISettingsView()
                .tabItem {
                    Text("API")
                }
                .tag(Tabs.general)
            CreditView()
                .tabItem {
                    Text("Credit")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(width: 375, height: 300)
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
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

struct AddressControlView: View {
    @State private var showPreview = true
    @State private var fontSize = 13.0
    @State private var clickedAddressIndex: Int? = nil
    @EnvironmentObject var prefs: Prefs
    var body: some View {
        Form {
            if let list = prefs.ethAddresses {
                List{
                    HStack{
                        Text("Address").font(.system(size: CGFloat(fontSize)))
                        Spacer()
                        Text("Delete").multilineTextAlignment(.trailing)
                    }
                    ForEach(list.indices, id: \.self) { i in
                        HStack{
                            Text("\(EthereumUtil.getAbbreviateAddress(list[i], (12,12)))").font(.system(size: CGFloat(fontSize)))
                            Spacer()
                            Button(action: {
                                self.clickedAddressIndex = i
                                self.deleteAddress()
                            }){
                                Text("ー")
                            }
                            .onHover(perform: { hovering in
                                if hovering {
                                    NSCursor.pointingHand.push()
                                    
                                } else {
                                    NSCursor.pop()
                                }
                            })
                            .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            HStack{
                Button(action: {
                    self.deleteAll()
                }){
                    Text("Remove all address")
                }
                .onHover(perform: { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                        
                    } else {
                        NSCursor.pop()
                    }
                })
                .multilineTextAlignment(.trailing)
            }
        }
        .padding(10)
    }
    
    func deleteAddress() {
        if var list = prefs.ethAddresses, let index = self.clickedAddressIndex {
            if list[index] == UserStatus.shared.activeAddress {
                NotificationCenter.default.post(name: .removeActiveAddress, object: nil)
            }
            list.remove(at: index)
            prefs.ethAddresses = list
            NotificationCenter.default.post(name: .addNewAddressMenu, object: nil)
        }
    }
    
    func deleteAll() {
        prefs.ethAddresses = []
        NotificationCenter.default.post(name: .resetAll, object: nil)
    }
}

struct APISettingsView: View {
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

struct CreditView: View {
    
    private let myEmailAddress = "felixinkor@gmail.com"
    private let myEthAddress = "0x911e63978E19E80725cd666306E27D724b043D44"
    var body: some View {
        VStack {
            HStack{
                Text("EyesOnEth").font(.largeTitle)
                Image("ethereum2").resizable().scaledToFit()
            }
            Spacer().frame(height: 30)
            Text("Ver 1.0.0").font(.subheadline)
            Text("Felix Chon").font(.subheadline)
            Spacer().frame(height: 30)
            HStack{
                Text(self.myEmailAddress).font(.footnote)
                    .toolTip("copy to clipboard")
                    .layoutPriority(1)
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.contextualMenu.push()
                            
                        } else {
                            NSCursor.pop()
                        }
                    })
                    .onTapGesture {
                        let board = NSPasteboard.general
                        board.clearContents()
                        board.setString(self.myEmailAddress, forType: .string)
                        NSCursor.pop()
                    }.multilineTextAlignment(.leading)
                Spacer()
                Text(EthereumUtil.getAbbreviateAddress(self.myEthAddress, (7,7))).font(.footnote)
                    .toolTip("copy to clipboard")
                    .layoutPriority(1)
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.contextualMenu.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                    .onTapGesture {
                        let board = NSPasteboard.general
                        board.clearContents()
                        board.setString(self.myEthAddress, forType: .string)
                        NSCursor.pop()
                    }.multilineTextAlignment(.trailing)
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
