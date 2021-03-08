import SwiftUI

struct CreditView: View {
    
    private let myEmailAddress = "felixinkor@gmail.com"
    private let myEthAddress = "0x911e63978E19E80725cd666306E27D724b043D44"
    var body: some View {
        VStack {
            HStack{
                Text("EyesOnEth").font(.title)
                Image("logo").resizable().scaledToFit()
            }
            Spacer().frame(height: 60)
            HStack{
                Text("Ver 1.0.0").font(.subheadline)
                Spacer().frame(height: 30)
                VStack(alignment: .trailing){
                    Text("Felix Chon").font(.subheadline)
                    Spacer().frame(height: 10)
                    Text(self.myEmailAddress).font(.footnote)
                        .toolTip("copy to clipboard")
                        .scaledToFill()
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
                        }
                }
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}
