import SwiftUI

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
